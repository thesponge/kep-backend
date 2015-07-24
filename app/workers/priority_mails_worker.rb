class PriorityMailsWorker
  include Sidekiq::Worker
  include Sidekiq::Extensions::ActiveRecord
  sidekiq_options :retry => 5 # Only 5 retries and then to the Dead Job Queue

  sidekiq_retries_exhausted do |msg|
   Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

  def perform(object_class, object_id, priority_id, p_id)
    priority = Priority.find(priority_id)
    object = Object.const_get(object_class).find(object_id)
    begin
      if priority && object && !priority.notified?
        object.private!
        no_hours = hours_since_start_of_batch(object,priority)
        #How long in sec a mail should be delayed
        dt = (no_hours * 3600) - (Time.current - priority.created_at).round
        PriorityMailer.delay_for(dt.seconds).notify_chosen(User.find(priority.chosen_id),object)
        priority.create_activity action: 'chosen_as_priority', recipient: priority.user,
          owner: object.user, start_time: Time.current + dt.seconds,parameters: {object_title: object.title}
        priority.delay_for(dt.seconds).update_attributes!(notified:true)
      end
    rescue =>e
      Sidekiq.logger.warn e.to_s
    end
  end

  def hours_since_start_of_batch(object,priority)
    levels = object.priorities.where(batch_number: priority.batch_number).map{|p| [p.level, p.no_hours]}.uniq.sort_by!{|x,y| x}
    #Calculate how many hours away from the start this level is
    no_hours = levels.take_while{|x,y| x < priority.level}.collect{|x,y| y}.inject(0, :+)
    return no_hours
  end

end
