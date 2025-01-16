require 'rails_helper'

describe 'Usuário visita a tela de criacao de evento' do
  it 'e não está autenticado' do
    visit root_path
    click_on 'Eventos'

    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'e está autenticado' do
    user = User.create!(email: 'user@email.com', name: 'user', family_name: 'last name', password: 'senha123', registration_number: '20990882098', role: 'user', confirmed_at: Time.current, confirmation_sent_at: Time.current)

    login_as user

    visit root_path

    expect(page).to have_content 'Eventos'
  end

  it 'e cria um evento com sucesso' do
    user = User.create!(email: 'user@email.com', name: 'user', family_name: 'last name', password: 'senha123', registration_number: '20990882098', role: 'user', confirmed_at: Time.current, confirmation_sent_at: Time.current)

    login_as user

    visit root_path
    click_on 'Eventos'
    click_on 'Criar Evento'

    fill_in 'Nome', with: 'Lollapaluza'
    fill_in 'Endereço', with: 'Rua X'
    select 'Presencial', from: 'Tipo de evento'
    fill_in 'Limite de participantes', with: 30
    fill_in 'URL do evento', with: 'www.Lollapaluza.com'
    attach_file('Logo', Rails.root.join('spec/support/images/logo.png'))
    attach_file('Banner', Rails.root.join('spec/support/images/banner.jpg'))
    find('trix-editor').set('<strong>test</strong>')
    click_on 'Criar'

    expect(page).to have_content 'Lollapaluza'
    expect(page).to have_content 'Evento criado com sucesso'
    expect(page).to have_content '<strong>test</strong>'
    expect(page).to have_selector "img"
  end

  it 'e não consegue criar um evento' do
    user = User.create!(email: 'user@email.com', name: 'user', family_name: 'last name', password: 'senha123', registration_number: '20990882098', role: 'user', confirmed_at: Time.current, confirmation_sent_at: Time.current)

    login_as user

    visit root_path
    click_on 'Eventos'
    click_on 'Criar Evento'

    click_on 'Criar'

    expect(page).to have_content 'Não foi possível criar o evento.'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Endereço não pode ficar em branco'
  end
end
