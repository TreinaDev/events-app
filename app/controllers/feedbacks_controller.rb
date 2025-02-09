class FeedbacksController < ApplicationController
  layout "dashboard_with_sidebar"
  before_action :authenticate_user!
  before_action :authorize_event_access
  before_action :check_if_event_ended
  add_breadcrumb "Home", :dashboard_path

  def index
    @feedbacks = @event.feedbacks
    @filtered_feedbacks = @feedbacks
    @target_rating = params[:rating].to_i
    if @target_rating && (1..5).include?(@target_rating)
      @filtered_feedbacks = @feedbacks.select { |feedback| feedback.mark == @target_rating.to_i }
    else
      @target_rating = nil
    end
    add_breadcrumb "#{@event.name}", Proc.new { event_path(@event) }
    add_breadcrumb "Feedbacks"

    respond_to do |format|
      format.html
      format.turbo_stream
    end

  rescue Rack::Timeout::RequestTimeoutException => error
    Rails.logger.error(error)
    @feedbacks = []
    @filtered_feedbacks = []
    add_breadcrumb "#{@event.name}", Proc.new { event_path(@event) }
    add_breadcrumb "Feedbacks - Evento #{@event.name}"
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
