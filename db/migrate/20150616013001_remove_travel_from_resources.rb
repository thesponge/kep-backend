class RemoveTravelFromResources < ActiveRecord::Migration
  def change
    remove_column :resources, :travel, :boolean
    remove_column :resources, :driver_license, :boolean
    remove_column :assignments, :travel, :boolean
    remove_column :assignments, :driver_license, :boolean
  end
end
