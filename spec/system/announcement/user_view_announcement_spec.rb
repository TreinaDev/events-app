require 'rails_helper'

describe 'Usuário tenta ver anuncios' do
  it 'e falha por não estar autenticado' do
    event = create(:event)
    visit event_announcements_path(event)

    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'e falha por conta do evento não estar publicado' do
    event = create(:event, status: :draft)

    visit event_announcements_path(event)
  end

  it 'com sucesso' do
    event_manager = create(:user, email: 'teste@email.com')
    event = create(:event, name: 'ccxp', status: :published, user: event_manager)
    create(:announcement, title: 'Distribuição de cartas One Piece', user: event_manager, event: event, description: 'perto do palco principal')

    login_as event_manager
    visit root_path

    click_on 'Gerenciar'
    click_on 'Comunicados'

    expect(page).to have_content 'Distribuição de cartas One Piece'
  end

  it 'e não vê comunicados de outro organizador' do
    event_manager = create(:user, email: 'teste@email.com')
    event = create(:event, name: 'ccxp', status: :published, user: event_manager)
    create(:announcement, title: 'Distribuição de cartas One Piece', user: event_manager, event: event, description: 'perto do palco principal')

    other_event_manager = create(:user, email: 'manoel@email.com')
    category = Category.create!(name: 'Culinária')
    other_event = create(:event, name: 'Curso de padeiro', status: :published, user: other_event_manager, categories: [ category ])
    create(:announcement, title: 'Lembrem de trazer seus utensílios', user: other_event_manager, event: other_event, description: 'não haverá utensílios para todos')


    login_as event_manager
    visit root_path

    click_on 'Gerenciar'
    click_on 'Comunicados'

    expect(page).to have_content 'Distribuição de cartas One Piece'
    expect(page).not_to have_content 'Lembrem de trazer seus utensílios'
  end
end
