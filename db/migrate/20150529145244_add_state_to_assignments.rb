class AddStateToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :state, :string
    add_column :assignments, :published_at, :datetime
  end
end
