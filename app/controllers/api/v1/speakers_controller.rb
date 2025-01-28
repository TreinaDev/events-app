class Api::V1::SpeakersController < Api::V1::ApiController
  def create
    speaker = Speaker.find_by(email: params[:email])

    if speaker
      render json: { token: speaker.token }, status: :ok
    else
      render json: { error: "Palestrante não encontrado." }, status: :not_found
    end
  end
end
