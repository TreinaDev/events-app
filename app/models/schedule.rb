class Schedule < ApplicationRecord
  belongs_to :event

  has_many :schedule_items

  validates :date, presence: true
end
