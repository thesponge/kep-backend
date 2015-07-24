class Assignment < ActiveRecord::Base
  include Filterable
  include PublicActivity::Model

  after_save :notify_progress, if: Proc.new{self.progress_percent_changed?}

  tracked owner: :user,
          recipient: :user,
          only: [:published, :completed, :progress_percent_changed, :closed_prematurely,
          :annouce_each_level, :all_prioritites_notified],
          params: {
            assign_title:-> (controller, model_instance) {model_instance.title}
          }

  belongs_to :user, inverse_of: :assignments

  has_and_belongs_to_many :assignment_rewards
  has_many :priorities, as: :prioritable
  has_many :score_account_assignments, inverse_of: :assignment
  has_many :assignment_bids, inverse_of: :assignment
  has_many :match_assignment_resources, inverse_of: :assignment
  has_many :location_maps, :as => :location_map
  has_many :locations, :through => :location_maps,
                       :after_remove => proc { |a| a.touch },
                       :after_add => proc { |a| a.touch unless a.new_record? }

  has_many :language_maps, :as => :language_map
  has_many :languages, :through => :language_maps,
                       :after_remove => proc { |a| a.touch },
                       :after_add => proc { |a| a.touch unless a.new_record?}

  has_many :skill_maps, :as => :skill_map
  has_many :skills, :through => :skill_maps,
                    :after_remove => proc { |a| a.touch },
                    :after_add => proc { |a| a.touch unless a.new_record?  }

  validates :title, presence: true, length: { in: 5..150 }
  validates :description, presence: true, length: { in: 50..3000}
  validates_inclusion_of :progress_percent, :in => 0..100

  scope :title, -> (title) {where title: title}

  state_machine :state, initial: :draft do

    event :draft do
      transition [:private, :published, :closed ] => :draft
    end

    event :private do
      transition [:draft, :published, :private] => :private
    end

    event :publish do
      transition [:draft, :private] => :published
    end

    event :go do
      transition :published => :ongoing
    end

    event :close do
      transition [:published, :ongoing] => :closed
    end

    event :complete do
      transition [:closed] => :completed
    end

    before_transition :draft => :published, do: :rec_pub_time
    after_transition [:draft, :private] => :published, do: :notify_going_public
    after_transition [:ongoing] => :closed, do: :notify_closed_prematurely
    after_transition [:closed] => :completed, do: :notify_completed
  end

  def annouce_each_level(priorities)
    priorities.map{|p| [p.level, p.no_hours]}.uniq.each do |level, no_hours|
      level_start = level * no_hours
      self.create_activity action: 'next_priorities_level', recipient: self.user,
        owner: self.user, start_time: priorities.last.created_at + level_start.hours
    end
  end

  private

  def rec_pub_time
    self.published_at = Time.now
  end

  def notify_going_public
    self.create_activity action: 'published'
  end

  def notify_progress
    self.create_activity action: 'progress_percent_changed',
      parameters: {progress_percent: self.progress_percent}
  end

  def notify_completed
    self.assignment_bids.where(chosen: true).each do |bid|
      self.create_activity action: 'completed', recipient: bid.user
    end
  end

  def notify_closed_prematurely
    if self.progress_percent < 100
      self.assignment_bids.where(chosen: true).each do |bid|
        self.create_activity action: 'closed_prematurely', recipient: bid.user,
         parameters: {progress_percent: self.progress_percent}
      end
    end
  end

end
