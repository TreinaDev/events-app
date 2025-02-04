class Verification < ApplicationRecord
  belongs_to :user
  belongs_to :reviewed_by, class_name: "User", foreign_key: "reviewed_by_id", optional: true

  enum :status, { pending: 1, approved: 3, rejected: 5 }, default: :pending
end
