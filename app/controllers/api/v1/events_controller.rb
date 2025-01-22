class Api::V1::EventsController < Api::V1::ApiController
  def index
    @events = Event.published.all

    render status: :ok, json: { events: @events.map do |event|
      {
        id: event.id,
        name: event.name,
        description: event.description.body.to_html,
        address: event.address
      }
    end
    }
  end
end
