class RemoveAddressFromEvent < ActiveRecord::Migration[8.0]
  def change
    remove_column :events, :address, :string
  end
end
