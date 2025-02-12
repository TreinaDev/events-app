class EventsController < ApplicationController
  layout :determine_layout
  before_action :authenticate_user!
  before_action :check_if_admin, only: [ :history ]
  before_action :authorize_event_access, only: [ :show, :publish, :destroy, :edit, :update ]
  before_action :check_event_status, only: [ :update ]
  before_action :check_if_event_manager, only: [ :index, :new, :create ]
  add_breadcrumb "Home", :dashboard_path

  def index
    @events = current_user.events
    add_breadcrumb "Meus Eventos", :events_path
  end

  def new
    @event = Event.new
    add_breadcrumb "Meus Eventos", :events_path
    add_breadcrumb "Cadastro de Evento"
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user

    if @event.save
      redirect_to @event, notice: "Evento criado com sucesso."
    else
      @event_places  = current_user.event_places
      flash.now[:alert] = "Não foi possível criar o evento."
      render :new, status: :unprocessable_entity
    end
  end

  def show
    add_breadcrumb "Meus Eventos", :events_path
    add_breadcrumb "#{@event.name}", :event_path
  end

  def edit
    add_breadcrumb "Meus Eventos", :events_path
    add_breadcrumb "#{@event.name}", :event_path
    add_breadcrumb "Editar Evento"
  end

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
    if current_user.role == "admin"
      return redirect_to history_events_path, notice: "Evento deletado com sucesso"
    end
    redirect_to dashboard_path, notice: "Evento deletado com sucesso"
  end

  def history
    @events = Event.with_discarded

    add_breadcrumb "Histórico de eventos"
  end

  private

  def determine_layout
    if [ "index", "new", "create", "history" ].include?(action_name)
      "dashboard"
    else
      "dashboard_with_sidebar"
    end
  end

  def event_params
    params.require(:event).permit(:name, :event_place_id, :event_type, :participants_limit, :url, :logo, :banner, :description, :start_date, :end_date, category_ids: [])
  end

  def authorize_event_access
    @event = Event.find(params[:id])
    unless @event.user == current_user || current_user.role == "admin"
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end

  def check_event_status
    if @event.published?
      redirect_to @event, alert: "Não é possível atualizar evento publicado"
    end
  end
end
