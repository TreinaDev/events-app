class Event < ApplicationRecord
  belongs_to :user

  enum :status, [ :draft, :published ]
  enum :event_type, [ :inperson, :online, :hybrid ]

  validates :name, :participants_limit, :url, :status, presence: true

  validates :address, presence: true, if: -> { inperson? || hybrid? }

  after_initialize :set_status, if: :new_record?

  private

  def set_status
    self.status ||= :draft
  end
end
