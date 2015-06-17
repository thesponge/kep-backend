class AssignmentBidSerializer < ActiveModel::Serializer
  attributes :id, :assignment_id, :user_id, :chosen, :created_at, :updated_at
end
