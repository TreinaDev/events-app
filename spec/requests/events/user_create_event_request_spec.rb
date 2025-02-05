require 'rails_helper'

describe 'Usuario tenta criar um evento' do
  it 'e falha pois não está autenticado' do
    post events_path

    expect(response).to redirect_to new_user_session_path
    expect(response).to have_http_status :found
  end

  it 'e falha por não ter enviado dados necessários' do
    user = create(:user)

    login_as user

    post events_path, params: { event: { name: '' } }

    expect(response).to have_http_status :unprocessable_entity
  end

  it 'e falha por ser um administrador' do
    user = create(:user, role: :admin)
    category = create(:category)

    login_as user

    post events_path, params: { event: { name: 'Lollapalooza', event_type: :online, participants_limit: 30, url: 'http://Lollapalooza.com', category_ids: [ category.id ], start_date: 1.month.from_now.strftime('%Y-%m-%d'), end_date: 2.months.from_now.strftime('%Y-%m-%d') } }

    expect(response).to redirect_to dashboard_path
    expect(Event.count).to equal 0
    expect(response).to have_http_status :found
  end

  it 'e cria um evento com sucesso' do
    user = create(:user)
    category = create(:category)

    login_as user

    post events_path, params: { event: { name: 'Lollapalooza', event_type: :online, participants_limit: 30, url: 'http://Lollapalooza.com', category_ids: [ category.id ], start_date: 1.month.from_now.strftime('%Y-%m-%d'), end_date: 2.months.from_now.strftime('%Y-%m-%d') } }

    expect(response).to redirect_to event_path(Event.last)
    expect(response).to have_http_status :found
  end
end
