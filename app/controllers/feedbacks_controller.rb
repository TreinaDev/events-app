class FeedbacksController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_event_access
  before_action :check_if_event_ended
  add_breadcrumb "Home", :dashboard_path
  add_breadcrumb "Meus Eventos", :events_path

  def index
    @feedbacks = @event.feedbacks

    add_breadcrumb "#{@event.name}", Proc.new { event_path(@event) }
    add_breadcrumb "Feedbacks"
  end

  private

  def authorize_event_access
    @event = Event.find(params[:event_id])
    unless @event.user == current_user || current_user.role == "admin"
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end

  def check_if_event_ended
    @event = Event.find(params[:event_id])
    unless @event.ended? && @event.status == "published"
      redirect_to root_path, alert: "Evento ainda está em andamento"
    end
  end
end
