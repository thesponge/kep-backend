class MatchAssignmentResourceSerializer < ActiveModel::Serializer
  attributes :id, :iso, :common

  belongs_to :assignment
  belongs_to :resource
  belongs_to :user
end
