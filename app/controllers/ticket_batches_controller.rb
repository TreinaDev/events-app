class TicketBatchesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :set_event
  before_action :check_if_event_manager

  def index
    @ticket_batches = @event.ticket_batches
  end

  def new
    @ticket_batch = TicketBatch.new
  end

  def create
    return redirect_to dashboard_path, alert: "Você não tem permissão para efetuar essa transação" if @event.user != current_user

    @ticket_batch = TicketBatch.new(ticket_batch_params)
    @ticket_batch.event = @event

    if @ticket_batch.save
      redirect_to event_ticket_batches_path(@event), notice: t(".success")
    else
      flash.now[:alert] = t(".failure")
      render :new, status: :unprocessable_entity
    end
  end

  private

  def ticket_batch_params
    params.require(:ticket_batch).permit(:name, :tickets_limit, :start_date, :end_date, :ticket_price, :discount_option)
  end

  def set_event
    @event = Event.find(params[:event_id])
  end
end
