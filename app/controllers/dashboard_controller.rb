class DashboardController < ApplicationController
  before_action :authenticate_user!
  layout "dashboard"
  add_breadcrumb "Home", :dashboard_path

  def index
    if current_user.event_manager?
      @events_count = current_user.events.count
      @published_events_count = current_user.events.published.count
      @last_published_events = current_user.events.published.order(created_at: :desc).limit(3)
    end

    if current_user.admin?
      users = User.event_manager.group(:verification_status).count
      @users_count = users.values.sum
      @verified_users_count = users["verified"] || 0
      @events_count = Event.count
      @published_events_count = Event.published.count
      @last_published_events = Event.published.order(created_at: :desc).limit(3)
      @pending_verifications = Verification.pending.order(created_at: :desc).limit(6)
      @pending_verifications_count = Verification.pending.count
      @reviewed_verifications = Verification.where.not(status: :pending).order(updated_at: :desc).limit(6)
    end
  end
end
