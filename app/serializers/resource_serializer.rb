class ResourceSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :description, :state, :created_at, :updated_at, :published_at

  has_many :intentions
  has_many :priorities
end
