class MatchUserUser < ActiveRecord::Base
  include PublicActivity::Model

  after_create :notify_nominee, :notitfy_second_nominee

  tracked owner: :matcher,
          only: [:matched_with_user],
          params: {
            matcher_name:-> (controller, model_instance) {model_instance.matcher.account.display_name}
          }

  belongs_to :matcher, class_name: "User", foreign_key: "matcher_id"
  belongs_to :nominee, class_name: "User", foreign_key: "nominee_id"
  belongs_to :second_nominee, class_name: "User", foreign_key: "second_nominee_id"

  validates :matcher_id, :nominee_id, :second_nominee_id, presence: true
  validates :nominee_id, uniqueness: { scope: :second_nominee_id}

  private

  def notify_nominee
    self.create_activity action: 'matched_with_user', recipient: self.nominee,
      parameters: { matched_name: self.second_nominee.account.display_name}
  end

  def notitfy_second_nominee
    self.create_activity action: 'matched_with_user', recipient: self.second_nominee,
      parameters: {matched_name: self.nominee.account.display_name}
  end
end
