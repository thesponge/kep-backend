class AssignmentBid < ActiveRecord::Base
  include PublicActivity::Model

  after_save :notify_chosen, if: Proc.new{self.chosen_changed? && self.chosen?}

  tracked owner: ->(controller, model) {controller && controller.current_user},
          recipient: ->(controller,model) {model.assignment.user},
          only: [:create,:notify_chosen],
          params: {
            assign_title:-> (controller, model_instance) {model_instance.assignment.title},
            actor_name: -> (controller, model_instance) {model_instance.user.account.display_name}
          }

  belongs_to :assignment, inverse_of: :assignment_bids
  belongs_to :user, inverse_of: :assignment_bids

  validates :assignment_id, :user_id, presence: true
  validates :assignment_id, uniqueness: { scope: :user_id}

  private

  def notify_chosen
    self.create_activity action: 'bid_chosen', owner: self.assignment.user ,
     recipient: self.user, parameters: {actor_name: self.assignment.user.account.display_name}
  end

end
