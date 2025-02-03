class EventPlacesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!

  def index
    @event_places = current_user.event_places
  end

  def new
    @event_place = EventPlace.new
  end

  def create
    @event_place = EventPlace.new(event_place_params)
    @event_place.user = current_user
    if @event_place.save
      redirect_to event_places_path, notice: "Local de Evento criado com sucesso."
    else
      flash.now[:alert] = "Falha ao criar o Local de Evento"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def event_place_params
    params.require(:event_place).permit(:name, :street, :number, :neighborhood, :city, :state, :zip_code, :photo)
  end
end
