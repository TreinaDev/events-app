class DashboardController < ApplicationController
  before_action :authenticate_user!
  layout "dashboard"
  add_breadcrumb "Home", :dashboard_path

  def index
    @events = current_user.events
  end
end
