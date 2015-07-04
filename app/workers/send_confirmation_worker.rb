class SendConfirmationWorker
  include Sidekiq::Worker

  def perform(object_class, object_id)
    object = Object.const_get(object_class).find(object_id)
    user = User.find(object.user_id)
    PriorityMailer.notify_owner(User.find(object.user_id),object).deliver_now
  end

end
