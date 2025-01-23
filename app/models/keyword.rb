class Keyword < ApplicationRecord
  has_many :category_keywords
  has_many :categories, through: :category_keywords

  validates :value, uniqueness: true
  validates :value, presence: true
end
