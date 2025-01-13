class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.integer :type
      t.string :address
      t.integer :participants_limit
      t.string :url
      t.integer :status

      t.timestamps
    end
  end
end
