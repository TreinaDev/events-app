class AnnouncementsController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :set_event
  before_action :check_if_published
  before_action :check_if_event_manager, only: [ :create ]

  def index
    @announcements = @event.announcements
    @announcement = Announcement.new
  end


  def create
    @announcement = Announcement.new(announcement_params)
    @announcement.user = current_user
    @announcement.event = @event
    if @announcement.save
      redirect_to event_announcements_path(@event), notice: t(".success")
    else
      @announcements = @event.announcements
      flash.now[:alert] = t(".failure")
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def announcement_params
    params.require(:announcement).permit(:title, :description)
  end

  def check_if_published
    if @event.status != "published"
      redirect_to event_path(@event), alert: "Só é possível fazer comunicados ao publicar evento"
    end
  end
end
