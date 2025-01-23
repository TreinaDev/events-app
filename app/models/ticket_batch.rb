class TicketBatch < ApplicationRecord
  belongs_to :event

  enum :discount_option, { no_discount: 1, student: 3, elderly: 5, disability: 7 }, default: :no_discount
end
