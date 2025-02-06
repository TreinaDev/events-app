class VerificationsController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :check_if_event_manager, only: [ :new, :create ]
  add_breadcrumb "Home", :dashboard_path

  def index
    @verifications = current_user.verifications.order(created_at: :desc) if current_user.role == "event_manager"
    @verifications = Verification.pending.order(created_at: :desc) if current_user.role == "admin"

    add_breadcrumb "Minhas Solicitações de Verificação" if current_user.role == "event_manager"
    add_breadcrumb "Solicitações de Verificação Pendentes" if current_user.role == "admin"
  end

  def new
    @user = current_user
    @user.build_user_address

    add_breadcrumb "Nova Solicitação de Verificação"
  end

  def create
    return redirect_to dashboard_path, alert: "Usuário já possui status verificado" if current_user.verification_status == "verified"
    @user = current_user

    @received_data = user_verification_params

    verification_request = Verification.new(user: @user)
    if @user.update(@received_data) && verification_request.save
      @user.verification_status = "pending"
      @user.save
      redirect_to dashboard_path, notice: "Sua requisição de análise do perfil foi criada com sucesso! Aguarde pela validação por um administrador"
    else
      flash.now[:alert] = "Erro ao enviar requisição de análise do perfil"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_verification_params
    params.require(:user).permit(:phone_number, :id_photo, :address_proof, user_address_attributes: [ :street, :number, :district, :city, :state, :zip_code ])
  end
end
