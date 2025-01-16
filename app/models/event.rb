class Event < ApplicationRecord
  belongs_to :user

  has_one_attached :logo
  has_one_attached :banner
  has_rich_text :description

  enum :status, [ :draft, :published ]
  enum :event_type, [ :inperson, :online, :hybrid ]

  validates :name, :participants_limit, :url, :status, presence: true
  validates :address, presence: true, if: -> { inperson? || hybrid? }
  validates :logo, content_type: { in: [ "image/png", "image/jpeg", "image/jpg" ], message: "deve ser uma imagem do tipo PNG, JPG ou JPEG" }
  validates :banner, content_type: { in: [ "image/png", "image/jpeg", "image/jpg" ], message: "deve ser uma imagem do tipo PNG, JPG ou JPEG" }

  validate :participants_limit_for_unverified_user

  after_initialize :set_status, if: :new_record?

  private

  def set_status
    self.status ||= :draft
  end

  def participants_limit_for_unverified_user
   if user && participants_limit
     if user.verification_status == "unverified" && participants_limit > 30
      errors.add(:participants_limit, "do evento não pode ser maior que 30 para usuários não verificados")
     end
   end
  end
end
