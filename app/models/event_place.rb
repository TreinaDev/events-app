class EventPlace < ApplicationRecord
  belongs_to :user

  has_one_attached :photo

  validates :name, :street, :number, :neighborhood, :city, :state, :zip_code, presence: true
end
