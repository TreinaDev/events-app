class Api::V1::AnnouncementsController < Api::V1::ApiController
  before_action :set_event

  def index
    render status: :ok, json: { announcements: @event.announcements.map do |announcement|
      {
        title: announcement.title,
        description: announcement.description.body ? announcement.description.body.to_html : "",
        created_at: announcement.created_at,
        code: announcement.code
      }
    end
    }
  end

  def show
    @announcement = @event.announcements.find_by(code: params[:code])

    return render status: :not_found, json: { error: "Announcement not found" } if @announcement.nil?

    render status: :ok, json: { announcement: {
      title: @announcement.title,
      description: @announcement.description.body ? @announcement.description.body.to_html : "",
      created_at: @announcement.created_at,
      code: @announcement.code
    } }
  end

  private

  def set_event
    @event = Event.find_by(code: params[:event_code])
  end
end
