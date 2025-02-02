class SchedulesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :authorize_schedule_access, only: [ :show ]
  before_action :find_event, only: [ :show ]


  def show
    if @schedule.nil?
      return redirect_to root_path, alert: "Acesso não autorizado."
    end

    @schedule = Schedule.find_by(id: params[:id])
    @schedule_items = @schedule.schedule_items.order(:start_time)
  end

  private

  def authorize_schedule_access
    @schedule = Schedule.find(params[:id])
    unless @schedule.event.user == current_user
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end

  def find_event
    @event = Event.find_by(id: params[:event_id])
  end
end
