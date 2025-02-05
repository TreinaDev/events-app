class EventPlaceRecommendationsController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :find_event_place, only: [ :new, :create, :edit, :update, :destroy ]
  before_action :find_event_place_recommendation, only: [ :edit, :update, :destroy ]

  def new
    @event_place_recommendation = EventPlaceRecommendation.new
  end

  def create
    @event_place_recommendation = EventPlaceRecommendation.new(event_place_recommendation_params)
    @event_place_recommendation.event_place = @event_place

    if @event_place_recommendation.save
      redirect_to @event_place, notice: "Recomendação de Local criada com sucesso."
    else
      flash.now[:alert] = "Falha ao criar a Recomendação de Local"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @event_place_recommendation = EventPlaceRecommendation.find_by(id: params[:id])
  end

  def update
    @event_place_recommendation = EventPlaceRecommendation.find_by(id: params[:id])

    if @event_place_recommendation.update(event_place_recommendation_params)
      redirect_to @event_place, notice: "Recomendação de Local atualizada com sucesso."
    else
      flash.now[:alert] = "Falha ao atualizar a Recomendação de Local"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event_place_recommendation.destroy
    redirect_to @event_place, notice: "Recomendação de Local excluida com sucesso."
  end

  private

  def event_place_recommendation_params
    params.require(:event_place_recommendation).permit(:name, :full_address, :phone)
  end

  def find_event_place
    @event_place = EventPlace.find_by(id: params[:event_place_id])

    if @event_place.nil? || @event_place.user != current_user
      redirect_to event_places_path
    end
  end

  def find_event_place_recommendation
    @event_place_recommendation = EventPlaceRecommendation.find_by(id: params[:id])

    if @event_place_recommendation.nil?
      redirect_to event_places_path
    end
  end
end
