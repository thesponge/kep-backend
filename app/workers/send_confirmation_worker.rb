class SendConfirmationWorker
  include Sidekiq::Worker
  include Sidekiq::Extensions::ActiveRecord

  def perform(object_class, object_id)
    object = Object.const_get(object_class).find(object_id)
    user = User.find(object.user_id)
    last_lvl_time = object.priorities.map{|p| [p.level, p.no_hours]}.sort_by!{|x,y| x}.last[1]
    PriorityMailer.notify_owner(User.find(object.user_id),object).deliver_now
    object.delay_for(last_lvl_time.hours).publish!
  end

end
