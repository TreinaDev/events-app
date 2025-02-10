class EventPlace < ApplicationRecord
  belongs_to :user
  has_many :events

  has_one_attached :photo

  has_many :event_place_recommendations

  validates :name, :street, :number, :neighborhood, :city, :state, :zip_code, presence: true
end
