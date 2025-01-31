require 'rails_helper'

describe 'Usuario tenta ver a dashboard' do
  it 'e falha pois não está autenticado' do
    get dashboard_path

    expect(response).to redirect_to new_user_session_path
    expect(response).to have_http_status :found
  end
end
