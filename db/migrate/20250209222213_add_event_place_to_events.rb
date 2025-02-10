class AddEventPlaceToEvents < ActiveRecord::Migration[8.0]
  def change
    add_reference :events, :event_place, foreign_key: true
  end
end
