class CreatePriorities < ActiveRecord::Migration
  def change
    create_table :priorities do |t|
      t.integer :chosen_id, null: false
      t.references :prioritable, polymorphic: true, index: true
      t.integer :no_hours, default: 3
      t.integer :level, null: false
      t.boolean :notified, default: false

      t.timestamps null: false
    end
  end
end
