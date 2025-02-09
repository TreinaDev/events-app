class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_event

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  protected

  def current_event
    @event ||= Event.find_by(id: params[:event_id]) || Event.find_by(id: params[:id])
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :family_name, :registration_number ])
  end

  def check_if_admin
    if current_user && current_user.role != "admin"
      redirect_to dashboard_path, alert: "Você não tem autorização para acessar essa página."
    end
  end

  def check_if_event_manager
    if current_user && current_user.role != "event_manager"
      redirect_to dashboard_path, alert: "Acesso não autorizado."
    end
  end
end
