# Object can be either an Assignment or a Resource
Superworker.define(:PrioritySuperworker, :object_class, :object_id, :priority_ids, :p_id) do
  batch priority_ids: :priority_id  do
    #p_id id put here because of a bug in superworkers parameters passing
    PriorityMailsWorker :object_class, :object_id, :priority_id, :p_id
  end
  SendConfirmationWorker :object_class, :object_id, :p_id
end

Sidekiq::Superworker.options[:superjob_expiration] = 2592000 #1 month

logger = Logger.new(Rails.root.join('log', 'superworker.log'))
logger.level = Logger::DEBUG
Sidekiq::Superworker::Logging.logger = logger
