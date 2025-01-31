class ChangeUuidColumn < ActiveRecord::Migration[8.0]
  def change
    rename_column :events, :uuid, :code
  end
end
