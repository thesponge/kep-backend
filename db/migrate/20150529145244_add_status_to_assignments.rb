class AddStatusToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :status, :string
    add_column :assignments, :published_at, :datetime
  end
end
