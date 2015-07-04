class Priority < ActiveRecord::Base
  belongs_to :prioritable, polymorphic: true
  belongs_to :user, foreign_key: "chosen_id", inverse_of: :priorities

  #Create multiple records from JSON
  def self.batch_create(post_content)
    begin
      Priority.transaction do
        JSON.parse(post_content).each do |priority_hash|
          Priority.create!(priority_hash)
        end
      end
    rescue => err
      logger.error(err.to_s.upcase)
    end
  end

end
