class ResourceSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :description, :created_at, :updated_at

  has_many :resource_priorities
  has_many :intentions
end
