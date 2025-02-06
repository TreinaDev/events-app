class Announcement < ApplicationRecord
  belongs_to :user
  belongs_to :event
  has_rich_text :description
  validates :title, :description, presence: true
  after_initialize :generate_unique_code, if: :new_record?

  def generate_unique_code
    loop do
      self.code = SecureRandom.alphanumeric(8).upcase
      break unless Announcement.where(code: code).exists?
    end
  end
end
