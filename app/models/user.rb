class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  enum :verification_status, { unverified: 1, pending: 3, verified: 5 }, default: :unverified
  enum :role, { event_manager: 1, admin: 3 }, default: :event_manager

  validates :name, :family_name, :registration_number, presence: true
  validates :registration_number, uniqueness: true

  validate :registration_number_validation

  after_create :skip_email_verification_for_non_admin_users

  def after_confirmation
    self.role = :admin if self.email.include? "@meuevento.com.br"
  end

  def registration_number_validation
    return if CPF.valid?(registration_number)

    errors.add(:registration_number, "Não é um CPF válido")
  end

  def skip_email_verification_for_non_admin_users
    self.confirm unless self.email.include? "@meuevento.com.br"
  end
end
