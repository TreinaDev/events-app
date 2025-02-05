class AddCodeToScheduleItems < ActiveRecord::Migration[8.0]
  def change
    add_column :schedule_items, :code, :string, null: false
    add_index :schedule_items, :code, unique: true
  end
end
