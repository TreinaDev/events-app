class Speaker < ApplicationRecord
  has_many :schedule_items, foreign_key: "responsible_email", primary_key: "email"
  has_many :schedules, through: :schedule_items
  has_many :events, through: :schedules

  validates :name, :code, :email, presence: true
  validates :email, :code, uniqueness: true

  after_initialize :generate_unique_code, if: :new_record?

  def generate_unique_code
    self.code = loop do
      random_code = SecureRandom.alphanumeric(8).upcase
      break random_code unless Speaker.exists?(code: random_code)
    end
  end
end
