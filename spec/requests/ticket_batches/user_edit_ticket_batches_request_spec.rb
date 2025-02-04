require 'rails_helper'

describe 'Usuário edita lote' do
  it 'e falha pois não está autenticado' do
    event = create(:event)
    batch = create(:ticket_batch, event: event)

    patch event_ticket_batch_path(event, batch)

    expect(response).to redirect_to new_user_session_path
    expect(response).to have_http_status :found
  end

  it 'e não consegue editar o lote de outro usuário sendo um usuário organizador' do
    user = create(:user, email: 'teste@email.com')
    category = create(:category, name: 'Tecnologia')
    event = create(:event, name: 'ccxp', status: :published, user: user, categories: [ category ])
    batch = create(:ticket_batch, event: event)

    marcelo = create(:user, email: 'marcelo@email.com')

    login_as marcelo
    patch event_ticket_batch_path(event, batch)

    expect(response).to have_http_status :redirect
    follow_redirect!
    follow_redirect!
    expect(response.body).to include 'Acesso não autorizado.'
  end
end
