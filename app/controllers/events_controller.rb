class EventsController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :set_event, only: [ :show, :publish, :destroy ]
  before_action :authorize_event_access, only: [ :show, :publish, :destroy ]

  def index
    @events = current_user.events
  end

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

  def publish
    @event.status = :published
    if @event.save
      redirect_to @event, notice: "Evento publicado com sucesso."
    end
  end

  def destroy
    @event.discard!
    redirect_to events_path, notice: "Evento deletado com sucesso"
  end

  private

  def event_params
    params.require(:event).permit(:name, :address, :event_type, :participants_limit, :url, :logo, :banner, :description, category_ids: [])
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def authorize_event_access
    unless @event.user == current_user
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end
end
