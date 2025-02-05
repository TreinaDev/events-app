class CreateUserAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :user_addresses do |t|
      t.string :street
      t.integer :number
      t.string :district
      t.string :city
      t.string :state, limit: 2
      t.string :zip_code
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
