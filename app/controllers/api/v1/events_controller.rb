class Api::V1::EventsController < Api::V1::ApiController
  def index
    @events = Event.published.all

    render status: :ok, json: { events: @events.map do |event|
      {
        id: event.id,
        name: event.name,
        description: event.description.body ? event.description.body.to_html : "",
        address: event.address,
        logo_url: event.logo.attached? ? url_for(event.logo) : nil,
        banner_url: event.banner.attached? ? url_for(event.banner) : nil,
        participants_limit: event.participants_limit,
        event_owner: event.user.name
      }
    end
    }
  end
end
