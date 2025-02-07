class EventPlaceRecommendation < ApplicationRecord
  belongs_to :event_place
  has_many :place_recommendations, dependent: :destroy
  has_many :events, through: :place_recommendations

  validates :name, :full_address, presence: true
  validates :phone, numericality: true, length: { in: 10..11 }, allow_blank: true
end
