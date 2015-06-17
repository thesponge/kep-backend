class MatchUserUserSerializer < ActiveModel::Serializer
  attributes :id, :matcher_id, :nominee_id, :second_nominee_id, :created_at, :updated_at
end
