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

    other_place = FactoryBot.create(:event_place)
    event_place = FactoryBot.create(:event_place, name: 'Casa do João', street: 'Rua do João', number: '123', neighborhood: 'Centro', city: 'São Paulo', zip_code: '12345-678', state: 'SP')

    login_as user

    visit new_event_path

    fill_in 'Nome', with: 'Lollapaluza'
    select 'Presencial', from: 'Tipo de evento'
    fill_in 'Limite de participantes', with: 30
    fill_in 'URL do evento', with: 'www.Lollapaluza.com'
    fill_in 'Data de início', with: 1.week.from_now.strftime('%Y-%m-%d')
    fill_in 'Data de fim', with: 2.weeks.from_now.strftime('%Y-%m-%d')
    attach_file('Logo', Rails.root.join('spec/support/images/logo.png'))
    attach_file('Banner', Rails.root.join('spec/support/images/banner.jpg'))
    find('trix-editor').click.set('<strong>test</strong>')
    select 'Casa do João', from: 'Local do evento'
    check 'Festa'
    check 'Palestra'
    click_on 'Criar'

    expect(page).to have_content 'Lollapaluza'
    expect(page).to have_content 'Evento criado com sucesso'
    expect(page).to have_content '<strong>test</strong>'
    expect(page).to have_selector "img"
    expect(page).to have_content "Agendas do Evento"
    within 'section' do
      expect(page).to have_selector "a", count: 8
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
