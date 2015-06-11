class CreateAssignmentBids < ActiveRecord::Migration
  def change
    create_table :assignment_bids do |t|
      t.belongs_to :assignment
      t.belongs_to :user
      t.boolean :chosen

      t.timestamps null: false
    end
  end
end
