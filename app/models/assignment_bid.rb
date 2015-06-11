class AssignmentBid < ActiveRecord::Base
  belongs_to :assignment, inverse_of: :assignment_bids
  belongs_to :user, inverse_of: :assignment_bids
end
