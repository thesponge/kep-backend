class PriorityMailsWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 10 # Only five retries and then to the Dead Job Queue

  sidekiq_retries_exhausted do |msg|
   Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

  def perform(object_class, object_id, priority_id)
    priority = Priority.find(priority_id)
    object = Object.const_get(object_class).find(object_id)
    begin
      if priority && object
        #Delivery time is calculated as level * no_hours chosen for each level
        dt = priority.level * priority.no_hours
        PriorityMailer.delay_for(dt.hours).notify_chosen(User.find(priority.chosen_id),object)
      end
    rescue =>err
      Sidekiq.logger.warn err.to_s
    end
  end

end
