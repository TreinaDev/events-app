class SchedulesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :authorize_schedule_access, only: [ :edit, :update, :show ]
  before_action :find_event, only: [ :edit, :update ]

  def edit
    @schedule = Schedule.find_by(id: params[:id])
  end

  def update
    @schedule = Schedule.find_by(id: params[:id])
    if @schedule.update(schedule_params)
      redirect_to @event, notice: "Datas editadas com sucesso."
    else
      flash.now[:alert] = "Não foi possível editar as datas."
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    if @schedule.nil?
      return redirect_to root_path, alert: "Acesso não autorizado."
    end

    @schedule = Schedule.find_by(id: params[:id])
    @schedule_items = @schedule.schedule_items
  end

  private

  def authorize_schedule_access
    @schedule = Schedule.find(params[:id])
    unless @schedule.event.user == current_user
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end

  def schedule_params
    params.require(:schedule).permit(:start_date, :end_date)
  end

  def find_event
    @event = Event.find_by(id: params[:event_id])
  end
end
