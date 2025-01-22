class Keyword < ApplicationRecord
  validates :value, uniqueness: true
  validates :value, presence: true
end
