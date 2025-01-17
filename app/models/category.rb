class Category < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: :name, message: "O nome dessa categoria já está em uso" }
end
