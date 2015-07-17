class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.belongs_to :user, null: false
      t.string :type
      t.boolean :seen, default: false
      t.string :content, null: false

      t.datetime :start_time, null:false, default: Time.now
      t.datetime :end_time
    end
  end
end
