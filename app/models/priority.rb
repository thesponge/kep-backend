class Priority < ActiveRecord::Base
  belongs_to :prioritable, polymorphic: true
  belongs_to :user, foreign_key: "chosen_id", inverse_of: :priorities
  after_commit :start_notifying

  #Create multiple records from JSON
  def self.batch_create(post_content)
    begin
      Priority.transaction do
        JSON.parse(post_content).each do |priority_hash|
          priority = Priority.create!(priority_hash)
        end
      end
    rescue => err
      logger.error(err.to_s.upcase)
    end
  end

  #Update multipe records from JSON
  def self.batch_update(patch_content)
    begin
      Priority.transaction do
        JSON.parse(patch_content).each do |priority_hash|
          priority = Priority.find_by(id: priority_hash["id"])
          if priority then priority.update!(priority_hash) end
        end
      end
    rescue => err
      logger.error(err.to_s)
    end
  end

  private

  def start_notifying
    NotifyPrioritiesJob.perform_later(self)
  end

end
