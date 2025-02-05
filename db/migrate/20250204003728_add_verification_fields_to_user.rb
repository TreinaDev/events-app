class AddVerificationFieldsToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :phone_number, :string
    add_column :users, :id_photo, :string
    add_column :users, :address_proof, :string
  end
end
