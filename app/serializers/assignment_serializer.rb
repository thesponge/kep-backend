class AssignmentSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :description, :travel, :driver_license, :state,
             :created_at, :updated_at

  has_many :locations
  has_many :languages
  has_many :skills
  has_many :assignment_rewards
  has_many :priorities
end
