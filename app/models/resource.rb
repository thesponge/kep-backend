class Resource < ActiveRecord::Base
  include PublicActivity::Model

  tracked owner: :user,
          recipient: :user,
          only: [:published, :annouce_each_level, :all_prioritites_notified],
          params: {
            resource_title:-> (controller, model_instance) {model_instance.title}
          }

  belongs_to :user, inverse_of: :resources
  has_many :priorities, as: :prioritable
  has_many :match_user_resources, inverse_of: :resource
  has_many :match_assignment_resources, inverse_of: :resource

  has_many :intention_maps, :as => :intention_map
  has_many :intentions, :through => :intention_maps,
                        :after_remove => proc { |a| a.touch },
                        :after_add => proc { |a| a.touch unless a.new_record?}


  validates :title, presence: true, length: { in: 5..150 }
  validates :description, presence: true, length: { in: 50..3000}

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

    event :close do
      transition [:published] => :closed
    end

    before_transition :draft => :published, do: :rec_pub_time
    after_transition [:draft, :private] => :published, do: :notify_going_public
  end

  def annouce_each_level(priorities)
    priorities.map{|p| [p.level, p.no_hours]}.uniq.each do |level, no_hours|
      level_start = level * no_hours
      self.create_activity action: 'next_priorities_level', recipient: self.user,
        owner: self.user, start_time: priorities.last.created_at + level_start.hours
    end
  end

  private

  def notify_going_public
    self.create_activity action: 'published'
  end

  def rec_pub_time
    self.published_at = Time.now
  end

end
