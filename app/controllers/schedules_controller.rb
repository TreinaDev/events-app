class SchedulesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :authorize_schedule_access, only: [ :show ]
  before_action :find_event, only: [ :show ]
  add_breadcrumb "Home", :dashboard_path

  def show
    @schedule = Schedule.find_by(id: params[:id])
    @schedule_items = @schedule.schedule_items.order(start_time: :asc)


    add_breadcrumb "#{@event.name}", Proc.new { event_path(@event) }
    add_breadcrumb "Agenda de #{I18n.l(@schedule.date.to_date, format: :short)}"
  end

  private

  def authorize_schedule_access
    @schedule = Schedule.find(params[:id])
    unless @schedule.event.user == current_user || current_user.role == "admin"
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end

  def find_event
    @event = Event.find_by(id: params[:event_id])
  end
end
