class ScheduleItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_schedule, only: [ :new, :create ]

  def new
    @schedule_item = @schedule.schedule_items.build
  end

  def create
    @schedule_item = ScheduleItem.new(schedule_items_params)
    @schedule_item.schedule = @schedule

    if @schedule_item.save
      redirect_to event_schedule_path(@schedule.event, @schedule), notice: "Item criado com sucesso."
    else
      flash.now[:alert] = "Não foi possível criar a atividade."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def schedule_items_params
    params.require(:schedule_item).permit(:name, :description, :start_time, :end_time, :responsible_name, :responsible_email, :schedule_type)
  end

  def find_schedule
    @schedule = Schedule.find(params[:schedule_id])
  end
end
