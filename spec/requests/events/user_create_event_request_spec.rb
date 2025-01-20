require 'rails_helper'

describe 'Usuario cria um evento' do
  it 'e falha pois não está autenticado' do
    post events_path

    expect(response).to redirect_to new_user_session_path
    expect(response).to have_http_status :found
  end

  it 'e falha por não ter enviado dados necessários' do
    user = FactoryBot.create(:user)

    login_as user

    post events_path, params: { event: { name: '' } }

    expect(response).to have_http_status :unprocessable_entity
  end

  it 'e cria um evento com sucesso' do
    user = FactoryBot.create(:user)
    category = FactoryBot.create(:category)

    login_as user

    post events_path, params: { event: { name: 'Lollapalooza', event_type: :online, participants_limit: 30, url: 'http://Lollapalooza.com', category_ids: [ category.id ] } }

    expect(response).to redirect_to event_path(Event.last)
    expect(response).to have_http_status :found
  end
end
