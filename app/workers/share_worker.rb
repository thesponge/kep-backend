class ShareWorker
  include Sidekiq::Worker

  sidekiq_options :retry => 5 # Only 5 retries and then to the Dead Job Queue

  sidekiq_retries_exhausted do |msg|
   Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

  def perform(user_id, object_class, object_id, email)
    object = Object.const_get(object_class).find(object_id)
    user = User.find(user_id)
    ShareMailer.share_object(user, object, email).deliver_later
  end

end
