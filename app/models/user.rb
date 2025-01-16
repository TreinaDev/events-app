class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :events

  enum :verification_status, { unverified: 1, pending: 3, verified: 5 }, default: :unverified
  enum :role, { event_manager: 1, admin: 3 }, default: :event_manager

  validates :name, :family_name, :registration_number, presence: true
  validates :registration_number, uniqueness: true

  validate :registration_number_validation

  after_validation :verify_if_user_has_admin_email

  def registration_number_validation
    return if CPF.valid?(registration_number)

    errors.add(:registration_number, "Não é um CPF válido")
  end

  def verify_if_user_has_admin_email
    self.role = :admin if self.email.include? "@meuevento.com.br"
  end
end
