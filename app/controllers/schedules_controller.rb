class SchedulesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :authorize_schedule_access, only: [ :edit, :update, :show ]
  before_action :find_event, only: [ :new, :create, :edit, :update ]

  def new
    if @event.schedule.present?
      return redirect_to event_path(@event), alert: "Este evento já possui uma agenda cadastrada."
    end

    @schedule = @event.build_schedule
  end

  def create
    @schedule = Schedule.new(schedule_params)
    @schedule.event = @event
    if @schedule.save
      redirect_to @event, notice: "Datas cadastradas com sucesso."
    else
      flash.now[:alert] = "Não foi possível criar a agenda."
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
