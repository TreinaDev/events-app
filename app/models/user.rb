class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  has_many :events
  has_one :user_address, dependent: :destroy
  accepts_nested_attributes_for :user_address
  has_one_attached :id_photo
  has_one_attached :address_proof

  enum :verification_status, { unverified: 1, pending: 3, verified: 5 }, default: :unverified
  enum :role, { event_manager: 1, admin: 3 }, default: :event_manager

  validates :name, :family_name, :registration_number, presence: true
  validates :registration_number, uniqueness: true
  validates :address_proof, content_type: [ "image/jpeg", "image/png", "image/jpg", "application/pdf", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document" ]
  validates :id_photo, content_type: [ "image/jpeg", "image/png", "image/jpg", "application/pdf", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document" ]

  validate :registration_number_validation

  before_validation :validate_optional_event_manager_fields_on_update, on: :update
  after_create :skip_email_verification_for_non_admin_users

  def after_confirmation
    if self.email.include? "@meuevento.com.br"
      self.role = :admin
      self.verification_status = :verified
      self.save!
    end
  end

  def validate_optional_event_manager_fields_on_update
    if self.role == "event_manager"
      self.errors.add(:phone_number, "não pode ficar em branco") if self.phone_number.blank?
      self.errors.add(:id_photo, "não pode ficar em branco") if self.id_photo.blank?
      self.errors.add(:address_proof, "não pode ficar em branco") if self.address_proof.blank?
    end
  end

  def registration_number_validation
    return if CPF.valid?(registration_number)

    errors.add(:registration_number, "Não é um CPF válido")
  end

  def skip_email_verification_for_non_admin_users
    self.confirm unless self.email.include? "@meuevento.com.br"
  end
end
