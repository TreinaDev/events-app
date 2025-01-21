class Schedule < ApplicationRecord
  belongs_to :event

  validates :start_date, :end_date, presence: true
end