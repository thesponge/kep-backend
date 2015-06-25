class CreatePriorities < ActiveRecord::Migration
  def change
    create_table :priorities do |t|
      t.integer :chosen_id
      t.references :prioritable, polymorphic: true, index: true
      t.integer :no_hours
      t.integer :level

      t.timestamps null: false
    end
  end
end
