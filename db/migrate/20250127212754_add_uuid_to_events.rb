class AddUuidToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :uuid, :string, null: false
    add_index :events, :uuid
  end
end
