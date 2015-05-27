class ScoreAccountAssignment < ActiveRecord::Base
  belongs_to :account
  belongs_to :assignment

  validates :account_id, uniqueness: { scope: :assignment_id }, presence: true
  validates :assignment_id, presence: true
  validates :total_score, presence: true, numericality: { greater_than: 10.00 }
end
