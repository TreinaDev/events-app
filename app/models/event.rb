class Event < ApplicationRecord
  include Discard::Model

  default_scope -> { kept }

  belongs_to :user

  has_one_attached :logo
  has_one_attached :banner
  has_rich_text :description
  has_many :event_categories
  has_many :ticket_batches
  has_many :categories, through: :event_categories
  has_many :schedules
  has_many :announcements
  has_many :place_recommendations
  has_many :event_place_recommendations, through: :place_recommendations

  enum :status, [ :draft, :published ]
  enum :event_type, [ :inperson, :online, :hybrid ]

  validates :code, uniqueness: true
  validates :name, :participants_limit, :url, :status, :start_date, :end_date, presence: true
  validates :address, presence: true, if: -> { inperson? || hybrid? }
  validates :logo, content_type: { in: [ "image/png", "image/jpeg", "image/jpg" ], message: "deve ser uma imagem do tipo PNG, JPG ou JPEG" }
  validates :banner, content_type: { in: [ "image/png", "image/jpeg", "image/jpg" ], message: "deve ser uma imagem do tipo PNG, JPG ou JPEG" }
  validates :start_date, :end_date, comparison: { greater_than: Time.now, message: "não pode ser depois da data atual" }
  validates :start_date, comparison: { less_than: :end_date, message: "não pode ser depois da data de fim", if: -> { end_date.present? } }
  validate :participants_limit_for_unverified_user
  validate :should_have_at_least_one_category

  after_create :set_schedules

  after_initialize :set_status, if: :new_record?
  before_validation :generate_code

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

  def generate_code
    loop do
      self.code = SecureRandom.alphanumeric(8).upcase
      break unless Event.where(code: code).exists?
    end
  end

  def set_schedules
    formatted_start_date = self.start_date.to_date
    formatted_end_date = self.end_date.to_date

    (formatted_start_date..formatted_end_date).each do |date|
      self.schedules.create(date: date)
    end
  end

  def self.search(query)
    return all if query.blank?

    query = query.downcase
    joins(:categories).where("LOWER(events.name) LIKE :query OR LOWER(events.code) LIKE :query OR LOWER(categories.name) LIKE :query", query: "%#{query}%").distinct
  end
end
