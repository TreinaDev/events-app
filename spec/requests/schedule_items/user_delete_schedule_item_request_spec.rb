require 'rails_helper'

describe 'Usuário tentar deletar item de agenda' do
  it 'e falha pois não está autenticado' do
    event = create(:event)
    schedule = create(:schedule, event: event)
    schedule_item = create(:schedule_item, schedule: schedule)

    delete event_schedule_item_path(event, schedule, schedule_item)

    expect(response).to redirect_to new_user_session_path
    expect(response).to have_http_status :found
  end

  it 'e não consegue deletar os itens de agenda dos outros' do
    first_user = create(:user, email: 'marcos@email.com')
    second_user = create(:user, email: 'joao@email.com')
    event = create(:event, user: second_user, name: "Conferência Ruby")
    schedule = create(:schedule, event: event)
    schedule_item = create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com")

    login_as first_user
    delete event_schedule_item_path(event, schedule, schedule_item)


    expect(response).to have_http_status :redirect
    follow_redirect!
    follow_redirect!
    expect(response.body).to include 'Acesso não autorizado.'
  end

  it 'com sucesso' do
    first_user = create(:user, email: 'marcos@email.com')
    event = create(:event, user: first_user, name: "Conferência Ruby")
    schedule = create(:schedule, event: event)
    schedule_item = create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com")

    login_as first_user
    delete event_schedule_item_path(event, schedule, schedule_item)


    expect(response).to have_http_status :redirect
    follow_redirect!
    expect(response.body).to include 'Item deletado com sucesso.'
  end
end
