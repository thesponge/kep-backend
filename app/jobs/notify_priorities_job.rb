class NotifyPrioritiesJob < ActiveJob::Base
  queue_as :default


  rescue_from ActiveJob::DeserializationError do |exception|
  # handle a deleted record
    Sidekiq.logger.warn "Failed with exception: #{exception.to_s}"
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
  #find how to cancel a job and do it here
    Sidekiq.logger.warn "Failed with exception: #{exception.to_s}"
    retry_job wait: 5.minutes
  end

  def perform(priority)
    #Delivery time is calculated as level * no_hours chosen for each level
    dt = priority.level * priority.no_hours
    related = Object.const_get(priority.prioritable_type).find(priority.prioritable_id)
    # PriorityMailer.notify_chosen(User.find(priority.chosen_id),related).deliver_later(wait: 3.minutes)
    PriorityMailer.delay_for(dt.hours).notify_chosen(User.find(priority.chosen_id),related)
  end


  def sent_confirm_mail
    # Sidekiq.logger.info "Priority is: #{priority.to_s}"
    # PriorityMailer.notify_owner(User.find(priority.chosen_id),related).deliver_now
  end

end
