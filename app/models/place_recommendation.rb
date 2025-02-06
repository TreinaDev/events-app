class PlaceRecommendation < ApplicationRecord
  belongs_to :event
  belongs_to :event_place_recommendation
end
