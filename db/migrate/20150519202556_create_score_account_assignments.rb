class CreateScoreAccountAssignments < ActiveRecord::Migration
  def change
    create_table :score_account_assignments do |t|
      t.references :account
      t.references :assignment
      t.decimal :total_score, precision: 5, scale: 2
      t.json :score_categories

      t.timestamps null: false
    end
  end
end
