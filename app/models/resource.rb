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

  private

  def start_notifying(priority)
    PrioritySuperworker.perform_async(self.class.to_s, self.id, self.priority_ids)
  end
end
