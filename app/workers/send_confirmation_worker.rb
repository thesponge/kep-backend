class SendConfirmationWorker
  include Sidekiq::Worker
  include Sidekiq::Extensions::ActiveRecord

  def perform(object_class, object_id, priority_id)
    object = Object.const_get(object_class).find(object_id)
    user = User.find(object.user_id)
    batch_total_time = batch_total_time(priority_id, object)
    last_lvl_time =last_level_time(priority_id,object)
    #When the last priority in the batch was created (i.e. when the timer starts) (datetime)
    start_time = Priority.find(priority_id).created_at
    #How long has passed since the creation of the priorities (sec)
    waste_time = (Time.current - start_time).round
    #How long the email should be delayed (sec)
    email_delay_time = ((batch_total_time - last_lvl_time) * 3600) - waste_time
    PriorityMailer.delay_for(email_delay_time.seconds).notify_owner(User.find(object.user_id),object,last_lvl_time)
    object.create_activity action: 'all_prioritites_notified', recipient: object.user,
      owner: object.user, start_time: Time.current + email_delay_time
    #How long the publishing should be delayed
    publish_delay_time =  (batch_total_time * 3600) - waste_time
    object.delay_for(publish_delay_time.seconds).publish!
  end

  def batch_total_time(priority_id,object)
    batch_nr = Priority.find(priority_id).batch_number
    levels = object.priorities.where(batch_number: batch_nr).map{|p| [p.level, p.no_hours]}.uniq
    sum = levels.sort_by!{|x,y| x}.collect{|x,y| y}.inject(0, :+)
    return sum
  end

  def last_level_time(priority_id,object)
    batch_nr = Priority.find(priority_id).batch_number
    no_hours = object.priorities.where(batch_number: batch_nr).map{|p| [p.level, p.no_hours]}.sort_by!{|x,y| x}.last[1]
    return no_hours
  end


end
