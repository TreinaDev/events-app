class VerificationsController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :check_if_event_manager, only: [ :new, :create ]

  def new
    @user = current_user
    @user.build_user_address
  end

  def create
    @user = current_user
    @user.update(user_verification_params)

    if @user.save
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
