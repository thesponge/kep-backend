class CreateAutomaticMatches < ActiveRecord::Migration
  def change
    create_table :automatic_matches do |t|
      t.integer :id_1
      t.string :table_name_1
      t.integer :id_2
      t.string :table_name_2
      t.decimal :total_score, precision: 5, scale: 2
      t.json :score_categories

      t.timestamps null: false
    end
  end
end
