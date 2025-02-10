class RemoveAddressFromEvents < ActiveRecord::Migration[8.0]
  def change
    remove_column :events, :address, :string
  end
end
