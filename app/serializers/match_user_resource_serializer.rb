class MatchUserResourceSerializer < ActiveModel::Serializer
  attributes :id, :matcher_id, :resource_id, :created_at, :updated_at
end
