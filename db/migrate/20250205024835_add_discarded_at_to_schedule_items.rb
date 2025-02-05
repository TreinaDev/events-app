class AddDiscardedAtToScheduleItems < ActiveRecord::Migration[8.0]
  def change
    add_column :schedule_items, :discarded_at, :datetime
    add_index :schedule_items, :discarded_at
  end
end
