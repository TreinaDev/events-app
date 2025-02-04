class EventPlacesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :check_if_event_manager

  def index
    @event_places = current_user.event_places
  end

  def show
    @event_place = EventPlace.find_by(id: params[:id])

    if @event_place.nil? || @event_place.user != current_user
      redirect_to event_places_path
    end
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

  def edit
    @event_place = EventPlace.find_by(id: params[:id])
    if @event_place.nil? || @event_place.user != current_user
      redirect_to event_places_path
    end
  end

  def update
    @event_place = EventPlace.find_by(id: params[:id])
    if @event_place.update(event_place_params)
      redirect_to @event_place, notice: "Local de Evento atualizado com sucesso."
    else
      flash.now[:alert] = "Falha ao atualizar o Local de Evento"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event_place = EventPlace.find_by(id: params[:id])
    if @event_place.user == current_user
      @event_place.destroy
      redirect_to event_places_path, notice: "Local de Evento excluido com sucesso."
    else
      redirect_to event_places_path, alert: "Não é possivel excluir esse Local de Evento."
    end
  end

  private

  def event_place_params
    params.require(:event_place).permit(:name, :street, :number, :neighborhood, :city, :state, :zip_code, :photo)
  end
end
