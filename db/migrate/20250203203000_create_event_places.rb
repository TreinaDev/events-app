class CreateEventPlaces < ActiveRecord::Migration[8.0]
  def change
    create_table :event_places do |t|
      t.string :name
      t.string :street
      t.string :number
      t.string :neighborhood
      t.string :city
      t.string :zip_code
      t.string :state
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
