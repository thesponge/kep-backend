class ScoreAccountAssignment < ActiveRecord::Base
  belongs_to :account, inverse_of: :score_account_assignments
  belongs_to :assignment, inverse_of: :score_account_assignments

  validates :account_id, uniqueness: { scope: :assignment_id }, presence: true
  validates :assignment_id, presence: true
  validates :total_score, presence: true, numericality: { greater_than: 10.00 }

  def as_json(options={})
    super(:include => {
            :account => {
              :only => [:display_name],
              :include => { :user => { :only => [:email, :created_at]}}
            }
          }
    )
  end

end
