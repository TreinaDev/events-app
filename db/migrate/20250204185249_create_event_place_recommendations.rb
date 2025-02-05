class CreateEventPlaceRecommendations < ActiveRecord::Migration[8.0]
  def change
    create_table :event_place_recommendations do |t|
      t.string :name
      t.string :full_address
      t.string :phone
      t.references :event_place, null: false, foreign_key: true

      t.timestamps
    end
  end
end
