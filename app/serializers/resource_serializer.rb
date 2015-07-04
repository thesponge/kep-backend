class ResourceSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :description, :created_at, :updated_at

  has_many :intentions
  has_many :priorities
end
