class AnnouncementsController < ApplicationController
  layout "dashboard_with_sidebar"
  before_action :authenticate_user!
  before_action :set_event
  before_action :check_if_published
  before_action :check_if_event_manager, only: [ :create ]

  add_breadcrumb "Home", :dashboard_path
  add_breadcrumb "Meus Eventos", :events_path


  def index
    @announcements = @event.announcements.order(created_at: :desc)
    @announcement = Announcement.new

    add_breadcrumb "#{@event.name}", Proc.new { event_path(@event) }
    add_breadcrumb "Comunicados"
  end



  def create
    @announcement = Announcement.new(announcement_params)
    @announcement.user = current_user
    @announcement.event = @event
    if @announcement.save
      redirect_to event_announcements_path(@event)
    else
      @announcements = @event.announcements.order(created_at: :desc)
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
