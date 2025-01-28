class Event < ApplicationRecord
  include Discard::Model
  belongs_to :user

  has_one_attached :logo
  has_one_attached :banner
  has_rich_text :description
  has_many :event_categories
  has_many :ticket_batches
  has_many :categories, through: :event_categories
  has_one :schedule

  enum :status, [ :draft, :published ]
  enum :event_type, [ :inperson, :online, :hybrid ]

  validates :name, :participants_limit, :url, :status, :start_date, :end_date, presence: true
  validates :address, presence: true, if: -> { inperson? || hybrid? }
  validates :logo, content_type: { in: [ "image/png", "image/jpeg", "image/jpg" ], message: "deve ser uma imagem do tipo PNG, JPG ou JPEG" }
  validates :banner, content_type: { in: [ "image/png", "image/jpeg", "image/jpg" ], message: "deve ser uma imagem do tipo PNG, JPG ou JPEG" }
  validates :start_date, :end_date, comparison: { greater_than: Time.now, message: "não pode ser depois da data atual" }
  validate :participants_limit_for_unverified_user
  validate :should_have_at_least_one_category

  after_initialize :set_status, if: :new_record?

  private

  def set_status
    self.status ||= :draft
  end

  def participants_limit_for_unverified_user
    return unless user && participants_limit

    if user.verification_status == "unverified" && participants_limit > 30
      errors.add(:participants_limit, "do evento não pode ser maior que 30 para usuários não verificados")
    end
  end

  def should_have_at_least_one_category
      errors.add(:categories, "deve ter ao menos uma categoria") if categories.empty?
  end
end
