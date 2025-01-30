class Speaker < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true
  validates :token, presence: true, uniqueness: true

  after_initialize :generate_unique_code, if: :new_record?

  def generate_unique_code
    self.token = loop do
      random_token = SecureRandom.alphanumeric(8).upcase
      break random_token unless Speaker.exists?(token: random_token)
    end
  end
end
