class Api::V1::EventsController < Api::V1::ApiController
  def index
    query = params[:query]
    @events = Event.published.search(query)

    events_data = @events.map do |event|
      data = {
        code: event.code,
        name: event.name,
        description: event.description.body ? event.description.body.to_html : "",
        event_type: event.event_type,
        address: event.address,
        logo_url: event.logo.attached? ? url_for(event.logo) : nil,
        banner_url: event.banner.attached? ? url_for(event.banner) : nil,
        participants_limit: event.participants_limit,
        event_owner: event.user.name,
        start_date: event.start_date,
        end_date: event.end_date
      }

      data.delete(:address) if event.online?
      data
    end

    render status: :ok, json: { events: events_data }
  end

  def show
    event = Event.published.find_by(code: params[:code])

    unless event
      return render status: :not_found, json: { error: "Evento não encontrado" }
    end

    event_data = {
      code: event.code,
      name: event.name,
      description: event.description.body ? event.description.body.to_html : "",
      event_type: event.event_type,
      address: event.address,
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

    event_data.delete(:address) if event.online?
    render status: :ok, json: event_data
  end
end
