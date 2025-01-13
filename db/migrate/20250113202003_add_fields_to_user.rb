class AddFieldsToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name, :string
    add_column :users, :family_name, :string
    add_column :users, :registration_number, :string
    add_column :users, :role, :integer, default: 1
    add_column :users, :verification_status, :integer, default: 1
  end
end
