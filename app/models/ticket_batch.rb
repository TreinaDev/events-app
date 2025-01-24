class TicketBatch < ApplicationRecord
  belongs_to :event

  enum :discount_option, { no_discount: 1, student: 3, elderly: 5, disability: 7 }, default: :no_discount

  before_save :apply_discount
  before_save :set_end_date_if_blank

  validates :name, :tickets_limit, :start_date, :ticket_price, :discount_option, presence: true

  private

  def set_end_date_if_blank
    self.end_date ||= self.event.schedule.start_date
  end

  def apply_discount
    if self.discount_option != :no_discount
      self.ticket_price /= 2
    end
  end
end
