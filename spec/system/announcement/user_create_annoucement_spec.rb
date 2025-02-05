require 'rails_helper'

describe 'Usuário tenta criar anúncio' do
  it 'com sucesso', js: true do
    event_manager = create(:user)
    create(:event, user: event_manager, status: :published)

    login_as event_manager
    visit root_path
    click_on 'Gerenciar'
    click_on 'Comunicados'
    fill_in 'announcement[title]', with: 'Palestra x foi cancelada'
    find('trix-editor').click.set('Por conta de y Evento')
    click_on 'Enviar'

    expect(page).to have_content 'Palestra x foi cancelada'
    expect(page).to have_content 'Por conta de y Evento'
    expect(page).to have_content "Comunicado adicionado com sucesso."
  end

  it 'e falha por não preencher campos obrigatórios' do
    event_manager = create(:user)
    create(:event, user: event_manager, status: :published)

    login_as event_manager
    visit root_path
    click_on 'Gerenciar'
    click_on 'Comunicados'
    click_on 'Enviar'

    expect(page).to have_content "Comunicado não foi adicionado."
  end
end
