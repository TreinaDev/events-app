class SchedulesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :authorize_schedule_access, only: [ :edit ]
  before_action :find_event, only: [ :new, :create, :edit, :update ]

  def new
    @schedule = @event.build_schedule
  end

  def create
    @schedule = Schedule.new(schedule_params)
    @schedule.event = @event
    if @schedule.save
      redirect_to @event, notice: "Datas cadastradas com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @schedule = Schedule.find_by(id: params[:id])
  end

  def update
    @schedule = Schedule.find_by(id: params[:id])
    if @schedule.update(schedule_params)
      redirect_to @event, notice: "Datas editadas com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
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
