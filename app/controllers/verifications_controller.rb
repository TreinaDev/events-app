class VerificationsController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :check_if_event_manager, only: [ :new, :create ]
  before_action :check_if_admin, only: [ :review ]
  before_action :authorize_verification_access, only: [ :show ]

  def index
    @verifications = current_user.verifications.order(created_at: :desc) if current_user.role == "event_manager"
    @verifications = Verification.pending.order(created_at: :desc) if current_user.role == "admin"
  end

  def new
    @user = current_user
    @user.build_user_address unless @user.user_address
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

  def show; end

  def review
    @verification = Verification.find_by(id: params[:verification_id])

    if @verification.status != "pending"
      return redirect_to @verification, alert: "Requisição já foi analisada."
    end

    status = params[:status]
    comment = params[:verification][:comment]
    @user = @verification.user

    if @verification.update(comment: comment, status: status)
      @user.verification_status = "verified" if status == "approved"
      @user.verification_status = "unverified" if status == "rejected"
      @user.save
      redirect_to @verification, notice: "Requisição de verificação analisada com sucesso."
    else
      flash.now[:alert] = "Erro ao analisar a requisição."
      @verification.reload
      render :show, status: :unprocessable_entity
    end
  end

  private

  def user_verification_params
    params.require(:user).permit(:phone_number, :id_photo, :address_proof, user_address_attributes: [ :street, :number, :district, :city, :state, :zip_code ])
  end

  def authorize_verification_access
    @verification = Verification.find_by(id: params[:id])
    unless @verification.user == current_user || current_user.role == "admin"
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end
end
