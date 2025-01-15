class Event < ApplicationRecord
  belongs_to :user

  has_one_attached :logo
  has_one_attached :banner

  enum :status, [ :draft, :published ]
  enum :event_type, [ :inperson, :online, :hybrid ]

  validates :name, :participants_limit, :url, :status, presence: true
  validates :address, presence: true, if: -> { inperson? || hybrid? }
  validates :logo, content_type: { in: [ "image/png", "image/jpeg", "image/jpg" ], message: "deve ser uma imagem do tipo PNG, JPG ou JPEG" }
  validates :banner, content_type: { in: [ "image/png", "image/jpeg", "image/jpg" ], message: "deve ser uma imagem do tipo PNG, JPG ou JPEG" }

  after_initialize :set_status, if: :new_record?

  private

  def set_status
    self.status ||= :draft
  end
end
