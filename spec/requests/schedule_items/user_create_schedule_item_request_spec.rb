require 'rails_helper'

describe 'Usuário cria um item de agenda' do
  it 'e falha pois não está autenticado' do
    post event_schedule_items_path(1, 1)

    expect(response).to redirect_to new_user_session_path
    expect(response).to have_http_status :found
  end

  it 'e falha pois não enviou os dados necessários' do
    user = create(:user)
    event = create(:event, user: user)
    schedule = create(:schedule, event: event)

    login_as user

    post event_schedule_items_path(event, schedule), params: { schedule_item: { name: '' } }

    expect(response).to have_http_status :unprocessable_entity
  end

  it 'e falha pois não é dono da agenda' do
    user = FactoryBot.create(:user)
    second_user = FactoryBot.create(:user, email: 'jose@email.com', registration_number: '30094462097')
    event = create(:event, user: user)
    schedule = create(:schedule, event: event)

    login_as second_user

    post event_schedule_items_path(event, schedule),
      params: { schedule_item: { name: 'Palestra', description: 'Palestra sobre Rails', responsible_name: 'João',
      responsible_email: 'joão@email.com', schedule_type: 'activity',
      start_time: (Time.now + 1.day).change(hour: 9, min: 0, sec: 0),
      end_time: (Time.now + 1.day).change(hour: 10, min: 0, sec: 0) }
      }

    expect(response).to redirect_to root_path
    expect(response).to have_http_status :found
  end

  it 'e cria um item de agenda com sucesso' do
    user = create(:user)
    event = create(:event, user: user)
    schedule = create(:schedule, event: event)

    login_as user

    post event_schedule_items_path(event, schedule),
      params: { schedule_item: { name: 'Palestra', description: 'Palestra sobre Rails', responsible_name: 'João',
      responsible_email: 'joão@email.com', schedule_type: 'activity',
      start_time: (Time.now + 1.day).change(hour: 9, min: 0, sec: 0),
      end_time: (Time.now + 1.day).change(hour: 10, min: 0, sec: 0) }
      }

    expect(response).to redirect_to event_schedule_path(event, schedule)
    expect(response).to have_http_status :found
  end
end
