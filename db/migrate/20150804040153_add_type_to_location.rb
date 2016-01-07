class AddTypeToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :location_type, :string, null: false, default: "residence"
  end
end
