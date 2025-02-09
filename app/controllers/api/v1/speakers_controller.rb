class Api::V1::SpeakersController < Api::V1::ApiController
  before_action :find_speaker, only: [ :event, :events, :schedules, :schedule_item ]

  def create
    if params[:email].blank?
      return render json: { error: "E-mail não fornecido" }, status: :bad_request
    end

    speaker = Speaker.find_by(email: params[:email])

    if speaker
      render json: { code: speaker.code }, status: :ok
    else
      render json: { error: "Palestrante não encontrado." }, status: :not_found
    end
  end

  def events
    events = @speaker.events.distinct.map do |event|
      {
        code: event.code,
        name: event.name,
        event_type: event.event_type,
        description: event.description.body ? event.description.body.to_html : "",
        address: event.address,
        logo_url: event.logo.attached? ? url_for(event.logo) : nil,
        banner_url: event.banner.attached? ? url_for(event.banner) : nil,
        participants_limit: event.participants_limit,
        event_owner: event.user.name,
        start_date: event.start_date,
        end_date: event.end_date
      }
    end

    render json: events, status: :ok
  end

  def event
    event = @speaker.events.find_by(code: params[:event_code])
    return render json: { error: "Palestrante não possui nenhum evento com esse código." }, status: :not_found unless event

    json_response = {
      code: event.code,
      name: event.name,
      event_type: event.event_type,
      description: event.description.body ? event.description.body.to_html : "",
      address: event.address,
      logo_url: event.logo.attached? ? url_for(event.logo) : nil,
      banner_url: event.banner.attached? ? url_for(event.banner) : nil,
      participants_limit: event.participants_limit,
      event_owner: event.user.name,
      start_date: event.start_date,
      end_date: event.end_date
    }

    render json: json_response, status: :ok
  end

  def schedules
    event = @speaker.events.find_by(code: params[:event_code])
    return render json: { error: "Palestrante não possui nenhum evento com esse código." }, status: :not_found unless event

    json_response = event.schedules.where(id: @speaker.schedules.pluck(:id)).map do |schedule|
      {
        date: schedule.date.strftime("%Y-%m-%d"),
        activities: schedule.schedule_items
                            .where(responsible_email: @speaker.email)
                            .as_json(except: [ :id, :schedule_id, :updated_at, :created_at ])
      }
    end

    render json: json_response, status: :ok
  end

  def schedule_item
    schedule_item = @speaker.schedule_items.find_by(code: params[:schedule_item_code])
    return render json: { error: "Palestrante não possui nenhum item de agenda com esse código." }, status: :not_found unless schedule_item

    event = schedule_item.schedule.event

    render json: schedule_item.as_json(except: [ :id, :updated_at, :discarded_at ]).merge(
      event: {
        code: event.code,
        start_date: event.start_date,
        end_date: event.end_date
      },
      schedule_date: schedule_item.schedule.date
    ), status: :ok
  end

  private

  def find_speaker
    @speaker = Speaker.find_by(code: speaker_code)
    render json: { error: "Código não pertence a nenhum palestrante." }, status: :not_found unless @speaker
  end

  def speaker_code
    params[:code] || params[:speaker_code]
  end
end
