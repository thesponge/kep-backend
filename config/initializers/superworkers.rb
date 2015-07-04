# Object can be either an Assignment or a Resource
Superworker.define(:PrioritySuperworker, :object_class, :object_id, :priority_ids) do
  batch priority_ids: :priority_id  do
    PriorityMailsWorker :object_class, :object_id, :priority_id
  end
  SendConfirmationWorker :object_class, :object_id
end

Sidekiq::Superworker.options[:superjob_expiration] = 2592000 #1 month

logger = Logger.new(Rails.root.join('log', 'superworker.log'))
logger.level = Logger::DEBUG
Sidekiq::Superworker::Logging.logger = logger
