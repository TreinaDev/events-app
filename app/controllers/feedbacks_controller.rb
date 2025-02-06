class FeedbacksController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_event_access

  def index
    @feedbacks = @event.feedbacks
  end

  private

  def authorize_event_access
    @event = Event.find(params[:event_id])
    unless @event.user == current_user || current_user.role == "admin"
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end
end
