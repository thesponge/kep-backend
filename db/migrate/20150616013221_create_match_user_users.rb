class CreateMatchUserUsers < ActiveRecord::Migration
  def change
    create_table :match_user_users do |t|
      t.integer :matcher_id
      t.integer :nominee_id
      t.integer :second_nominee_id

      t.timestamps null: false
    end
  end
end
