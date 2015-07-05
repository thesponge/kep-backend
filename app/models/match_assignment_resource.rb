class MatchAssignmentResource < ActiveRecord::Base
  belongs_to :assignment, inverse_of: :match_assignment_resources
  belongs_to :resource, inverse_of: :match_assignment_resources
  belongs_to :user, inverse_of: :match_assignment_resources
  # make sure assignment.user_id is not the same as resource.user_id?

  validates :assignment_id, uniqueness: { scope: :resource_id}
end
