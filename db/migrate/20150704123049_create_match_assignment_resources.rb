class CreateMatchAssignmentResources < ActiveRecord::Migration
  def change
    create_table :match_assignment_resources do |t|
      t.belongs_to :assignment, null: false
      t.belongs_to :resource, null: false
      t.integer    :matcher_id

      t.timestamps null: false
    end
  end
end
