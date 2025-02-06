class ScheduleItemsController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :authorize_schedule_owner, only: [ :new, :create, :destroy, :edit, :update ]
  before_action :find_schedule_item, only: [ :edit, :update, :destroy ]
  add_breadcrumb "Home", :dashboard_path


  def new
    @schedule_item = @schedule.schedule_items.build

    add_breadcrumb "#{@schedule.event.name}", Proc.new { event_path(@schedule.event) }
    add_breadcrumb "Agenda de #{I18n.l(@schedule.date.to_date, format: :short)}", Proc.new { event_path(@schedule.event) }
    add_breadcrumb "Cadastro de Atividade"
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

  def edit
    add_breadcrumb "#{@schedule.event.name}", Proc.new { event_path(@schedule.event) }
    add_breadcrumb "Agenda de #{I18n.l(@schedule.date.to_date, format: :short)}", Proc.new { event_path(@schedule.event) }
    add_breadcrumb "Editar Atividade - #{@schedule_item.name}"
  end

  def update
    if @schedule_item.update(schedule_items_params)
      redirect_to event_schedule_path(@schedule_item.schedule.event, @schedule_item.schedule), notice: "Item atualizado com sucesso."
    else
      flash.now[:alert] = "Falha ao atualizar o item"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
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

  def find_schedule_item
    @schedule_item = ScheduleItem.find_by(id: params[:id])

    unless @schedule_item.schedule.event.user == current_user
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end
end
