class ScoreAccountAssignment < ActiveRecord::Base
  include PublicActivity::Model

  tracked owner:-> (controller, model_instance) {model_instance.assignment.user},
          recipient:-> (controller, model_instance) {model_instance.account.user},
          only: [:create],
          params: {
            assign_title:-> (controller, model_instance) {model_instance.assignment.title},
            score: -> (controller, model_instance) {model_instance.total_score}
          }

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
