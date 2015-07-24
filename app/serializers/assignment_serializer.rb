class AssignmentSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :description, :state,
             :start_date, :end_date, :progress_percent, :created_at, :updated_at,
             :published_at

  has_many :locations
  has_many :languages
  has_many :skills
  has_many :assignment_rewards
  has_many :priorities
  has_many :assignment_bids

end
