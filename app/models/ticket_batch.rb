class TicketBatch < ApplicationRecord
  belongs_to :event

  enum :discount_option, { no_discount: 1, student: 3, elderly: 5, disability: 7 }, default: :no_discount

  before_save :apply_discount
  before_save :set_end_date_if_blank
  validate :check_capacity

  validates :name, :tickets_limit, :start_date, :ticket_price, :discount_option, presence: true
  validates :start_date, comparison: { less_than: :end_date, message: "não pode ser depois da data de fim", if: -> { end_date.present? } }
  # validates :end_date, comparison: { less_than_or_equal_to: ->(ticket_batch) { ticket_batch.event.start_date }, message: "não pode ser depois da data de início do evento", if: -> { event.present? }  }
  validate :end_date_before_event_start

  private

  def end_date_before_event_start
    if end_date.present? && event.present? && end_date > event.start_date
      errors.add(:end_date, "deve ser anterior à data de início do evento")
    end
  end

  def set_end_date_if_blank
    self.end_date ||= self.event.start_date
  end

  def apply_discount
    if self.discount_option != :no_discount
      self.ticket_price /= 2
    end
  end

  def check_capacity
    return if tickets_limit.nil? || event.participants_limit.nil?

    total_tickets = event.ticket_batches.sum(&:tickets_limit)

    if total_tickets + tickets_limit > event.participants_limit
      errors.add(:tickets_limit, "não deve ultrapassar o limite do evento")
    end
  end
end
