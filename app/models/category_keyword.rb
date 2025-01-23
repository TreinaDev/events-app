class CategoryKeyword < ApplicationRecord
  belongs_to :category
  belongs_to :keyword
end
