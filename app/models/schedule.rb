class Schedule < ApplicationRecord
  belongs_to :event

  validates :start_date, :end_date, presence: true
  validate :validate_dates

  private

  def validate_dates
    return unless start_date.present? && end_date.present?

    if start_date >= end_date
      errors.add(:start_date, "deve vir antes da data de fim")
    end
  end
end
