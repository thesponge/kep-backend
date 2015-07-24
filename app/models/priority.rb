class Priority < ActiveRecord::Base
  include PublicActivity::Model
  include SecureRandom

  tracked only: [:chosen_as_priority]

  belongs_to :prioritable, polymorphic: true
  belongs_to :user, foreign_key: "chosen_id", inverse_of: :priorities

  validates :prioritable_type, :inclusion => %w(Assignment Resource)
  validates :batch_number, presence: true

  #Create multiple records from JSON
  def self.batch_create(post_content)
    priorities = []
    batch_nr = SecureRandom.hex
    begin
      Priority.transaction do
        JSON.parse(post_content).each do |priority_hash|
          priority_hash[:batch_number] = batch_nr
          priorities << Priority.create!(priority_hash)
        end
        if priorities.map{|p| [p.prioritable_type, p.prioritable_id]}.uniq.size != 1
          raise PrioritableIconsistencyError.new()
        end
      end
        priority = priorities.first
        priority_ids = priorities.map{|p| p.id}
        priority.prioritable.annouce_each_level(priorities)
        PrioritySuperworker.perform_async(priority.prioritable_type,
          priority.prioritable_id, priority_ids, priority.id)
        return priorities
    rescue => err
      return err
    end
  end

end
