class RemoveTravelFromResources < ActiveRecord::Migration
  def change
    remove_column :resources, :travel, :boolean
    remove_column :resources, :driver_license, :boolean
  end
end
