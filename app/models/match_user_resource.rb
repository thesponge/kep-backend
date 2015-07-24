class MatchUserResource < ActiveRecord::Base
  include PublicActivity::Model

  after_create :notify_nominee, :notify_resource_owner

  tracked owner: :matcher,
          only: [:notify_nominee, :notify_resource_owner],
          params: {
            matcher_name:-> (controller, model_instance) {model_instance.matcher.account.display_name},
            resource_title:-> (controller, model_instance) {model_instance.resource.title}
          }

  belongs_to :resource, inverse_of: :match_user_resources
  belongs_to :matcher, class_name: "User", foreign_key: "matcher_id"
  belongs_to :nominee, class_name: "User", foreign_key: "nominee_id"

  validates :matcher_id, :resource_id, :nominee_id, presence: true
  validates :resource_id, uniqueness: { scope: :nominee_id}

  private

  def notify_nominee
    self.create_activity action: 'matched_with_resource', recipient: self.nominee
  end

  def notify_resource_owner
    self.create_activity action: 'resource_matched_with_user', recipient: self.resource.user,
    parameters: {matched_name: self.nominee.account.display_name}
  end

end
