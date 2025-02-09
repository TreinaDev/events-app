class TicketBatchesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :authorize_event_access
  before_action :set_ticket_batch, only: [ :edit, :update ]
  add_breadcrumb "Home", :dashboard_path
  add_breadcrumb "Meus Eventos", :events_path

  def index
    @ticket_batches = @event.ticket_batches

    add_breadcrumb "#{@event.name}", Proc.new { event_path(@event) }
    add_breadcrumb "Lotes de Ingresso - Evento #{@event.name}"
  end

  def new
    @ticket_batch = TicketBatch.new

    add_breadcrumb "#{@event.name}", Proc.new { event_path(@event) }
    add_breadcrumb "Lotes de Ingresso - Evento #{@event.name}", Proc.new { event_ticket_batches_path(@event) }
    add_breadcrumb "Criar Lote"
  end

  def create
    return redirect_to dashboard_path, alert: "Você não tem permissão para efetuar essa transação" if @event.user != current_user && current_user.role != "admin"

    @ticket_batch = TicketBatch.new(ticket_batch_params)
    @ticket_batch.event = @event

    if @ticket_batch.save
      redirect_to event_ticket_batches_path(@event), notice: t(".success")
    else
      flash.now[:alert] = t(".failure")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    add_breadcrumb "#{@event.name}", Proc.new { event_path(@event) }
    add_breadcrumb "Lotes de Ingresso - Evento #{@event.name}", Proc.new { event_ticket_batches_path(@event) }
    add_breadcrumb "Editar Lote"
  end

  def update
    if @ticket_batch.update(ticket_batch_params)
      redirect_to event_ticket_batches_path(@event), notice: t(".success")
    else
      flash.now[:alert] = t(".failure")
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_ticket_batch
    @ticket_batch = TicketBatch.find(params[:id])
  end

  def ticket_batch_params
    params.require(:ticket_batch).permit(:name, :tickets_limit, :start_date, :end_date, :ticket_price, :discount_option)
  end

  def authorize_event_access
    @event = Event.find(params[:event_id])
    unless @event.user == current_user || current_user.role == "admin"
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end
end
