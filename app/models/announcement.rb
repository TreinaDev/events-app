class Announcement < ApplicationRecord
  belongs_to :user
  belongs_to :event
  has_rich_text :description
  validates :title, :description, presence: true
end
