class MatchUserUser < ActiveRecord::Base
  belongs_to :matcher, class_name: "User", foreign_key: "matcher_id"
  belongs_to :nominee, class_name: "User", foreign_key: "nominee_id"
  belongs_to :second_nominee, class_name: "User", foreign_key: "second_nominee_id"

  validates :matcher_id, :nominee_id, :second_nominee_id, presence: true
  validates :nominee_id, uniqueness: { scope: :second_nominee_id}
end
