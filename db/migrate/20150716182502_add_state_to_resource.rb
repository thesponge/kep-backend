class AddStateToResource < ActiveRecord::Migration
  def change
    add_column :resources, :state, :string
    add_column :resources, :published_at, :datetime
  end
end
