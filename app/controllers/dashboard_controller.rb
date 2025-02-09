class DashboardController < ApplicationController
  before_action :authenticate_user!
  layout "dashboard"
  add_breadcrumb "Home", :dashboard_path

  def index
    @events = current_user.events

    if current_user.event_manager?
      @events_count = current_user.events.count
      @published_events_count = current_user.events.published.count
      @last_published_events = current_user.events.published.order(created_at: :desc).limit(3)
    end
  end
end
