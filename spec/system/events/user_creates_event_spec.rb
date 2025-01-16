require 'rails_helper'

describe 'Usuário visita a tela de criacao de evento' do
  it 'e não está autenticado' do
    visit new_event_path

    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'e está autenticado' do
    user = FactoryBot.create(:user)

    login_as user

    visit new_event_path

    expect(page).to have_content 'Novo Evento'
  end

  it 'e cria um evento com sucesso' do
    user = FactoryBot.create(:user)
    Category.create!(name: 'Festa')
    Category.create!(name: 'Palestra')

    login_as user

    visit new_event_path

    fill_in 'Nome', with: 'Lollapaluza'
    fill_in 'Endereço', with: 'Rua X'
    select 'Presencial', from: 'Tipo de evento'
    fill_in 'Limite de participantes', with: 30
    fill_in 'URL do evento', with: 'www.Lollapaluza.com'
    attach_file('Logo', Rails.root.join('spec/support/images/logo.png'))
    attach_file('Banner', Rails.root.join('spec/support/images/banner.jpg'))
    find('trix-editor').set('<strong>test</strong>')
    check 'Festa'
    check 'Palestra'
    click_on 'Criar'

    expect(page).to have_content 'Lollapaluza'
    expect(page).to have_content 'Evento criado com sucesso'
    expect(page).to have_content '<strong>test</strong>'
    expect(page).to have_selector "img"
  end

  it 'e não consegue criar um evento' do
    user = FactoryBot.create(:user)

    login_as user

    visit new_event_path

    click_on 'Criar'

    expect(page).to have_content 'Não foi possível criar o evento.'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Endereço não pode ficar em branco'
  end
end
