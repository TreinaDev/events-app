class Category < ApplicationRecord
  has_many :category_keywords
  has_many :keywords, through: :category_keywords

  validates :name, presence: true, uniqueness: { scope: :name, message: "O nome dessa categoria já está em uso" }
end
