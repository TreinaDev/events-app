require 'rails_helper'

describe 'Usuário edita item de agenda' do
  it 'e falha por não estar autenticado' do
    user = create(:user)
    event = create(:event, user: user)
    schedule_item = create(:schedule_item, schedule: event.schedules.first)

    patch event_schedule_item_path(event, event.schedules.first, schedule_item),
          params: { schedule_item: { responsible_name: 'Novo nome' } }

    expect(response).to redirect_to new_user_session_path
    expect(response.status).to eq 302
  end

  it 'e falha por tentar editar um item de agenda de um evento do qual não é dono' do
    user = create(:user)
    event = create(:event, user: user)
    schedule_item = create(:schedule_item, schedule: event.schedules.first)
    other_user = create(:user, email: 'not_the@owner.com', password: 'password123')

    login_as other_user
    patch event_schedule_item_path(event, event.schedules.first, schedule_item),
          params: { schedule_item: { responsible_name: 'Novo nome' } }

    expect(response).to redirect_to root_path
    expect(response.status).to eq 302
  end

  it 'com sucesso' do
    user = create(:user)
    event = create(:event, user: user)
    schedule_item = create(:schedule_item, schedule: event.schedules.first)

    login_as user

    patch event_schedule_item_path(event, event.schedules.first, schedule_item),
          params: { schedule_item: { responsible_name: 'Novo nome' } }

    expect(response).to redirect_to event_schedule_path(event, event.schedules.first)
    expect(response.status).to eq 302
  end
end
