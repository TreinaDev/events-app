class CreateVerifications < ActiveRecord::Migration[8.0]
  def change
    create_table :verifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :reviewed_by, null: true, foreign_key:  { to_table: :users }
      t.integer :status, default: 1
      t.text :comment

      t.timestamps
    end
  end
end
