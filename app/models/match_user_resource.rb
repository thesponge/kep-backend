class MatchUserResource < ActiveRecord::Base
  belongs_to :resource, inverse_of: :match_user_resources
  belongs_to :matcher, class_name: "User", foreign_key: "matcher_id"
  belongs_to :nominee, class_name: "User", foreign_key: "nominee_id"

  validates :matcher_id, :resource_id, :nominee_id, presence: true
  validates :resource_id, uniqueness: { scope: :nominee_id}
end
