class DashboardController < ApplicationController
  before_action :authenticate_user!
  layout "dashboard"
  def index
    @events = current_user.events
  end
end
