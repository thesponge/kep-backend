class MatchAssignmentResource < ActiveRecord::Base
  include PublicActivity::Model

  after_create :notify_assign_owner, :notify_resource_owner

  tracked owner: :matcher,
          only: [:resource_matched_with_assignment, :assignment_matched_with_resource],
          params: {
            matcher_name:-> (controller, model_instance) {model_instance.matcher.account.display_name},
            resource_title:-> (controller, model_instance) {model_instance.resource.title},
            assignment_title:-> (controller, model_instance) {model_instance.assignment.title}
          }

  belongs_to :assignment, inverse_of: :match_assignment_resources
  belongs_to :resource, inverse_of: :match_assignment_resources
  belongs_to :matcher, class_name: "User", foreign_key: "matcher_id", inverse_of: :match_assignment_resources
  # make sure assignment.user_id is not the same as resource.user_id?

  validates :assignment_id, uniqueness: { scope: :resource_id}

  private

  def notify_resource_owner
    self.create_activity action: 'resource_matched_with_assignment', recipient: self.resource.user
  end

  def notify_assign_owner
    self.create_activity action: 'assignment_matched_with_resource', recipient: self.assignment.user
  end
end
