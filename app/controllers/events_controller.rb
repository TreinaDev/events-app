class EventsController < ApplicationController
  before_action :authenticate_user!

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

  def show
    @event = Event.find(params[:id])
  end

  def publish
    @event = Event.find(params[:id])
    @event.status = :published
    if @event.save
      redirect_to @event, notice: "Evento publicado com sucesso."
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :address, :event_type, :participants_limit, :url, :logo, :banner, :description, category_ids: [])
  end
end
