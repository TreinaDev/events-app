class ScheduleItemsController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :authorize_schedule_owner, only: [ :new, :create, :destroy ]

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

  def destroy
    @schedule_item = ScheduleItem.find_by(id: params[:id])

    @schedule_item.discard!
    redirect_to event_schedule_path(@schedule_item.schedule.event, @schedule_item.schedule), notice: "Item deletado com sucesso."
  end

  private

  def schedule_items_params
    params.require(:schedule_item).permit(:name, :description, :start_time, :end_time, :responsible_name, :responsible_email, :schedule_type)
  end

  def authorize_schedule_owner
    @schedule = Schedule.find(params[:schedule_id])

    unless @schedule.event.user == current_user
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end
end
