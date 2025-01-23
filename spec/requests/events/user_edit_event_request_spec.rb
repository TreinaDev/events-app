require 'rails_helper'

describe 'Usuário edita evento' do
  it 'e falha pois não está autenticado' do
    event = FactoryBot.create(:event)

    patch event_path(event)

    expect(response).to redirect_to new_user_session_path
    expect(response).to have_http_status :found
  end

  it 'e não consegue editar os eventos dos outros' do
    user = create(:user, email: 'teste@email.com')
    category = create(:category, name: 'Tecnologia')
    first_user_event = create(:event, name: 'ccxp', status: :published, user: user, categories: [ category ])
    marcelo = create(:user, email: 'marcelo@email.com')
    create(:event, name: 'Introdução ao RoR', user: marcelo, categories: [ category ])

    login_as marcelo
    patch event_path(first_user_event)

    expect(response).to have_http_status :redirect
    follow_redirect!
    follow_redirect!
    expect(response.body).to include 'Acesso não autorizado.'
  end

  it 'e não consegue editar um evento publicado' do
    user = create(:user, email: 'teste@email.com')
    category = create(:category, name: 'Tecnologia')
    first_user_event = create(:event, name: 'ccxp', status: :published, user: user, categories: [ category ])

    login_as user
    patch event_path(first_user_event)

    expect(response).to have_http_status :redirect
    follow_redirect!
    expect(response.body).to include 'Não é possível atualizar evento publicado'
  end
end
