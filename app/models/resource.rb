class Resource < ActiveRecord::Base
  belongs_to :user, inverse_of: :resources
  has_many :priorities, as: :prioritable,
    after_add: :start_notifying
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
      transition [:draft, :published] => :private
    end

    event :publish do
      transition [:draft, :private] => :published
    end

    event :close do
      transition [:published] => :closed
    end

    before_transition :draft => :published, do: :rec_pub_time
  end


  private

  def rec_pub_time
    self.published_at = Time.now
  end

  def start_notifying(priority)
    PrioritySuperworker.perform_async(self.class.to_s, self.id, self.priority_ids)
  end

end
