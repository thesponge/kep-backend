class AddBatchNumberToPriorities < ActiveRecord::Migration
  def change
    add_column :priorities, :batch_number, :string, null: false
  end
end
