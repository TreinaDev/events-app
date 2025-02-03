class Api::V1::SpeakersController < Api::V1::ApiController
  def create
    if params[:email].blank?
      return render json: { error: "E-mail não fornecido" }, status: 400
    end

    speaker = Speaker.find_by(email: params[:email])

    if speaker
      render json: { token: speaker.token }, status: :ok
    else
      render json: { error: "Palestrante não encontrado." }, status: :not_found
    end
  end

  def events
    speaker = Speaker.find_by(token: params[:token])

    if speaker
      events = speaker.events.distinct.as_json(except: [ :id, :user_id, :discarded_at, :updated_at ])
      render json: events, status: :ok
    else
      render json: { error: "Token não pertence a nenhum palestrante." }, status: :not_found
    end
  end

  def schedules
    speaker = Speaker.find_by(token: params[:speaker_token])
    return render json: { error: "Token não pertence a nenhum palestrante." }, status: :not_found unless speaker

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
