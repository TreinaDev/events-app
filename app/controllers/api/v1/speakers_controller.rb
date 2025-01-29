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
end
