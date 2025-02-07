class Api::V1::EventsController < Api::V1::ApiController
  def index
    query = params[:query]
    @events = Event.published.search(query)

    render status: :ok, json: { events: @events.map do |event|
      {
        code: event.code,
        name: event.name,
        description: event.description.body ? event.description.body.to_html : "",
        address: { name: event.event_place.name,
                   street: event.event_place.street,
                   number: event.event_place.number,
                   neighborhood: event.event_place.neighborhood,
                   city: event.event_place.city,
                   zip_code: event.event_place.zip_code,
                   state: event.event_place.state },
        logo_url: event.logo.attached? ? url_for(event.logo) : nil,
        banner_url: event.banner.attached? ? url_for(event.banner) : nil,
        participants_limit: event.participants_limit,
        event_owner: event.user.name,
        start_date: event.start_date,
        end_date: event.end_date,
        recommendations: event.event_place.event_place_recommendations.map do |recommendation|
          {
            name: recommendation.name,
            full_address: recommendation.full_address,
            phone: recommendation.phone
          }
        end
      }
    end
    }
  end

  def show
    event = Event.published.find_by(code: params[:code])

    unless event
      return render status: :not_found, json: { error: "Event not found" }
    end

    render status: :ok, json: {
      code: event.code,
      name: event.name,
      description: event.description.body ? event.description.body.to_html : "",
      address: { name: event.event_place.name,
                   street: event.event_place.street,
                   number: event.event_place.number,
                   neighborhood: event.event_place.neighborhood,
                   city: event.event_place.city,
                   zip_code: event.event_place.zip_code,
                   state: event.event_place.state },
      logo_url: event.logo.attached? ? url_for(event.logo) : nil,
      banner_url: event.banner.attached? ? url_for(event.banner) : nil,
      participants_limit: event.participants_limit,
      event_owner: event.user.name,
      start_date: event.start_date,
      end_date: event.end_date,
      ticket_batches: event.ticket_batches,
      schedules: event.schedules.map do |schedule|
        {
          date: schedule.date.strftime("%Y-%m-%d"),
          schedule_items: schedule.schedule_items.map do |item|
            {
              code: item.code,
              name: item.name,
              description: item.description,
              start_time: item.start_time,
              end_time: item.end_time,
              responsible_name: item.responsible_name,
              responsible_email: item.responsible_email,
              schedule_type: item.schedule_type
            }
          end
        }
      end
    }
  end
end
