class Api::V1::TicketBatchesController < Api::V1::ApiController
  def index
    @event = Event.find_by(code: params[:event_code])
    render status: :ok, json: { ticket_batches: @event.ticket_batches.map do |ticket_batch|
      {
        name: ticket_batch.name,
        tickets_limit: ticket_batch.tickets_limit,
        start_date: ticket_batch.start_date,
        end_date: ticket_batch.end_date,
        ticket_price: ticket_batch.ticket_price,
        discount_option: ticket_batch.discount_option,
        event_id: ticket_batch.event.id,
        code: ticket_batch.code
      }
    end
    }
  end

  def show
    @event = Event.find_by(code: params[:event_code])
    @ticket_batch = @event.ticket_batches.find_by(code: params[:code])

    return render status: :not_found, json: { error: "Ticket batch not found" } if @ticket_batch.nil?

    render status: :ok, json: { ticket_batch: {
      name: @ticket_batch.name,
      tickets_limit: @ticket_batch.tickets_limit,
      start_date: @ticket_batch.start_date,
      end_date: @ticket_batch.end_date,
      ticket_price: @ticket_batch.ticket_price,
      discount_option: @ticket_batch.discount_option,
      event_id: @ticket_batch.event.id,
      code: @ticket_batch.code
    } }
  end
end
