class CreatePlaceRecommendations < ActiveRecord::Migration[8.0]
  def change
    create_table :place_recommendations do |t|
      t.references :event, null: false, foreign_key: true
      t.references :event_place_recommendation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
