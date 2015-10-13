class AssignmentReward < ActiveRecord::Base

  update_index('kep#assignment') { assignments }

  has_and_belongs_to_many :assignments

  validates :reward, presence: true
end
