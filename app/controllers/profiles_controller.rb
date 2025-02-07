class ProfilesController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  before_action :check_verified, only: [ :edit, :update ]
  before_action :set_user_profile
  add_breadcrumb "Home", :dashboard_path

  def show
    add_breadcrumb "Meu Perfil"
  end

  def edit
    add_breadcrumb "Meu Perfil", :profile_path
    add_breadcrumb "Editar Perfil"
  end

  def update
    if @user.update(user_params)
      redirect_to profile_path, notice: t(".success")
    else
      flash.now[:alert] = t(".failure")
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def check_verified
    return if current_user.admin?
    redirect_to profile_path, alert: "Apenas usuários verificados podem atualizar o perfil" unless current_user.verified?
  end

  def set_user_profile
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :family_name, :avatar)
  end
end
