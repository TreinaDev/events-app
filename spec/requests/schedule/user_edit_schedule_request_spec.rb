require 'rails_helper'

describe 'Usuário edita uma agenda' do
  it 'e falha pois não está autenticado' do
    patch event_schedule_path(1, 1)

    expect(response).to redirect_to new_user_session_path
    expect(response).to have_http_status :found
  end

  it 'e falha pois não enviou dados necessários' do
    user = create(:user)
    event = create(:event, user: user)
    schedule = create(:schedule, event: event)

    login_as user

    patch event_schedule_path(event, schedule), params: { schedule: { start_date: '' } }

    expect(response).to have_http_status :unprocessable_entity
  end

  it 'e falha pois o evento é de outro usuário' do
    user = create(:user)
    second_user = create(:user, email: 'joao@email.com')
    event = create(:event, user: second_user)
    schedule = create(:schedule, event: event)

    login_as user

    patch event_schedule_path(event, schedule), params: { schedule: {
      start_date: (Time.now + 1.day).change(hour: 8, min: 0, sec: 0),
      end_date: (Time.now + 2.day).change(hour: 8, min: 0, sec: 0) }
    }

    expect(response).to redirect_to root_path
    expect(response).to have_http_status :found
  end

  it 'com sucesso' do
    user = create(:user)
    event = create(:event, user: user)
    schedule = create(:schedule, event: event)

    login_as user

    patch event_schedule_path(event, schedule), params: { schedule: {
      start_date: (Time.now + 1.day).change(hour: 8, min: 0, sec: 0),
      end_date: (Time.now + 2.day).change(hour: 8, min: 0, sec: 0) }
    }

    expect(response).to redirect_to event_path(event)
    expect(response).to have_http_status :found
  end
end
