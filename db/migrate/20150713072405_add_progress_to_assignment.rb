class AddProgressToAssignment < ActiveRecord::Migration
  def change
    add_column :assignments, :progress_percent, :integer, default: 0 
  end
end
