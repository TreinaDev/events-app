class EventPlaceRecommendation < ApplicationRecord
  belongs_to :event_place

  validates :name, :full_address, presence: true
  validates :phone, numericality: true, length: { in: 10..11 }
end
