class ScoreAccountAssignment < ActiveRecord::Base
  belongs_to :account
  belongs_to :assignment
end
