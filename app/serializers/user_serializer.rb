class UserSerializer < ActiveModel::Serializer
  attributes :id, :email
  has_many :assignments
  has_many :resources
  has_one :account
end
