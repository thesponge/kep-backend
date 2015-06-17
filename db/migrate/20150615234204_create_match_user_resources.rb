class CreateMatchUserResources < ActiveRecord::Migration
  def change
    create_table :match_user_resources do |t|
      t.belongs_to :resource
      t.integer :matcher_id
      t.integer :nominee_id

      t.timestamps null: false
    end
  end
end
