class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :return_500

  def return_500
    render json: {}, status: 500
  end
end
