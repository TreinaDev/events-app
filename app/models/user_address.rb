class UserAddress < ApplicationRecord
  belongs_to :user

  validates :street, :number, :district, :city, :state, :zip_code, presence: true
  validates :number, numericality: { only_integer: true, greater_than: 0 }
  validates :state, inclusion: { in: [ "AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO" ], message: "precisa ser uma sigla dos estados válidos (MG, SP...)" }
end
