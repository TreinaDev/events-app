class AddDiscardedAtToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :discarded_at, :datetime
    add_index :events, :discarded_at
  end
end
