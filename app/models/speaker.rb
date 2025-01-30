class Speaker < ApplicationRecord
  has_many :schedule_items, foreign_key: "responsible_email", primary_key: "email"
  has_many :schedules, through: :schedule_items
  has_many :events, through: :schedules

  validates :name, :token, :email, presence: true
  validates :email, :token, uniqueness: true

  after_initialize :generate_unique_code, if: :new_record?

  def generate_unique_code
    self.token = loop do
      random_token = SecureRandom.alphanumeric(8).upcase
      break random_token unless Speaker.exists?(token: random_token)
    end
  end
end
