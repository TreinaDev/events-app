require 'rails_helper'

describe 'Usuário ve histórico de eventos' do
  it 'e falha por não estar autenticado' do
    visit history_events_path

    expect(current_path).to eq new_user_session_path
  end

  it 'e falha por não ser um administrador' do
    user = create(:user, role: :event_manager)
    login_as user
    visit history_events_path

    expect(current_path).to eq dashboard_path
  end

  it 'com sucesso' do
    admin = create(:user, role: :admin)

    category = create(:category, name: 'Tecnologia')
    ccxp = create(:event, name: 'ccxp', status: :published, user: admin, categories: [ category ])
    ccxp.discard!
    create(:event, name: 'Introdução ao RoR', user: admin, categories: [ category ])

    login_as admin
    visit root_path
    click_on 'Histórico de eventos'

    expect(page).to have_content 'ccxp'
    expect(page).to have_content 'Introdução ao RoR'
  end
end
