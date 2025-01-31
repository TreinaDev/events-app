class EventsController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :authorize_event_access, only: [ :show, :publish, :destroy, :edit, :update ]
  before_action :check_event_status, only: [ :update ]

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user

    if @event.save
      redirect_to @event, notice: "Evento criado com sucesso."
    else
      flash.now[:alert] = "Não foi possível criar o evento."
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @event.update event_params
      redirect_to @event, notice: "Evento atualizado com sucesso"
    else
      flash.now[:alert] = "Falha ao atualizar o Evento"
      render :edit, status: :unprocessable_entity
    end
  end

  def publish
    unless @event.banner.attached? && @event.logo.attached?
      flash.now[:alert] = "Banner e Logo são obrigatórios ao publicar um Evento."
      return render :show, status: :unprocessable_entity
    end

    @event.status = :published
    if @event.save
      redirect_to @event, notice: "Evento publicado com sucesso."
    end
  end

  def destroy
    @event.discard!
    redirect_to dashboard_path, notice: "Evento deletado com sucesso"
  end

  private

  def event_params
    params.require(:event).permit(:name, :address, :event_type, :participants_limit, :url, :logo, :banner, :description, :start_date, :end_date, category_ids: [])
  end

  def authorize_event_access
    @event = Event.find(params[:id])
    unless @event.user == current_user
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end

  def check_event_status
    if @event.published?
      redirect_to @event, alert: "Não é possível atualizar evento publicado"
    end
  end
end
