require 'rails_helper'

describe 'Usuário tenta criar anúncio' do
  it 'com sucesso', js: true do
    event_manager = create(:user)
    create(:event, user: event_manager, status: :published)

    login_as event_manager
    visit root_path
    within "nav#navbar" do
      click_on 'Meus Eventos'
    end
    click_on 'Gerenciar'
    find('a[href*="announcements"]').click
    fill_in 'announcement[title]', with: 'Palestra x foi cancelada'
    find('trix-editor').click.set('Por conta de y Evento')
    click_on 'Enviar'

    expect(page).to have_content 'Palestra x foi cancelada'
    expect(page).to have_content 'Por conta de y Evento'
  end

  it 'e falha por não preencher campos obrigatórios' do
    event_manager = create(:user)
    event = create(:event, name: 'ccxp', status: :published, user: event_manager)
    create(:announcement, title: 'Distribuição de cartas One Piece', user: event_manager, event: event)
    create(:announcement, title: 'Transporte da estação Luz', user: event_manager, event: event)


    login_as event_manager
    visit root_path
    within "nav#navbar" do
      click_on 'Meus Eventos'
    end
    click_on 'Gerenciar'
    find('a[href*="announcements"]').click
    click_on 'Enviar'

    announcements = all('[data-announcement-title]')
    expect(announcements.map(&:text)).to eq [ 'Transporte da estação Luz', 'Distribuição de cartas One Piece' ]
    expect(page).to have_content "Comunicado não foi adicionado."
  end
end
