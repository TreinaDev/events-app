require 'rails_helper'

describe 'Usuário visita a tela de criacao de evento' do
  it 'e não está autenticado' do
    visit new_event_path

    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'e está autenticado' do
    user = create(:user)

    login_as user

    visit new_event_path

    expect(page).to have_content 'Cadastro de Evento'
  end


  it 'e cria um evento com sucesso', js: true do
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
    fill_in 'Data de início', with: 1.day.from_now.strftime('%Y-%m-%dT%H:%M')
    fill_in 'Data de fim', with: 9.days.from_now.strftime('%Y-%m-%dT%H:%M')
    attach_file('Logo', Rails.root.join('spec/support/images/logo.jpg'))
    attach_file('Banner', Rails.root.join('spec/support/images/banner.png'))
    find('trix-editor').click.set('<strong>test</strong>')
    check 'Festa'
    check 'Palestra'
    click_on 'Criar'

    expect(page).to have_content 'Lollapaluza'
    expect(page).to have_content 'Evento criado com sucesso'
    expect(page).to have_content '<strong>test</strong>'
    expect(page).to have_selector "img"
    expect(page).to have_content "Agendas do Evento"
    within 'aside' do
      expect(page).to have_selector "a", count: 9
    end
  end

  it 'e não consegue criar um evento' do
    user = create(:user)

    login_as user

    visit new_event_path

    click_on 'Criar'

    expect(page).to have_content 'Não foi possível criar o evento.'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Endereço não pode ficar em branco'
  end
end
