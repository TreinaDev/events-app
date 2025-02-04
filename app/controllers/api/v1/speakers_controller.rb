class Api::V1::SpeakersController < Api::V1::ApiController
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
    speaker = Speaker.find_by(code: params[:code])

    if speaker
      events = speaker.events.distinct.map do |event|
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
    else
      render json: { error: "Código não pertence a nenhum palestrante." }, status: :not_found
    end
  end

  def schedules
    speaker = Speaker.find_by(code: params[:speaker_code])
    return render json: { error: "Código não pertence a nenhum palestrante." }, status: :not_found unless speaker

    event = Event.find_by(code: params[:event_code])
    return render json: { error: "Código não pertence a nenhum evento." }, status: :not_found unless event

    json_response = event.schedules.where(id: speaker.schedules.pluck(:id)).map do |schedule|
      {
        date: schedule.date.strftime("%Y-%m-%d"),
        activities: schedule.schedule_items
                            .where(responsible_email: speaker.email)
                            .as_json(except: [ :id, :schedule_id, :updated_at, :created_at ])
      }
    end

    return render json: { error: "O palestrante não possui nenhuma atividade nesse evento." }, status: :not_found if json_response.empty?

    render json: json_response, status: :ok
  end
end
