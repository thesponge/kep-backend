class Assignment < ActiveRecord::Base
  include Filterable
  belongs_to :user, inverse_of: :assignments

  has_and_belongs_to_many :assignment_rewards
  has_many :priorities, as: :prioritable,
    after_add: :start_notifying
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
  validates :progress_percent, :inclusion => {:in => [0,100]}

  scope :title, -> (title) {where title: title}
  scope :travel, -> (travel) {where travel: travel}
  scope :driver_license, -> (driver_license) {where driver_license: driver_license}

  state_machine :state, initial: :draft do

    event :draft do
      transition [:private, :published, :closed ] => :draft
    end

    event :private do
      transition [:draft, :published] => :private
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
  end

  private

  def rec_pub_time
    self.published_at = Time.now
  end

  def start_notifying(priority)
    job = PrioritySuperworker.perform_async(self.class.to_s, self.id, self.priority_ids)
  end

end
