class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
          :confirmable

  enum :verification_status, { unverified: 1, pending: 3, verified: 5 }, default: :unverified
end
