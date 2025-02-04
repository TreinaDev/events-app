require 'rails_helper'

describe 'Usuário cria local de evento' do
  it 'e não está autenticado' do
    visit new_event_place_path

    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    user = create(:user)
    login_as user

    visit dashboard_path
    within 'nav' do
      click_on 'Meus Locais'
    end

    click_on 'Novo Local'

    fill_in 'Nome', with: 'Arena de Grêmio'
    fill_in 'Rua', with: 'Av. Padre Leopoldo Brentano'
    fill_in 'Número', with: '110'
    fill_in 'Bairro', with: 'Farrapos'
    fill_in 'Cidade', with: 'Porto Alegre'
    fill_in 'CEP', with: '90250590'
    select 'RS', from: 'Estado'
    click_on 'Cadastrar'

    expect(page).to have_content('Local de Evento criado com sucesso.')
    expect(page).to have_content('Arena de Grêmio')
    expect(page).to have_content('Av. Padre Leopoldo Brentano')
    expect(page).to have_content('110')
    expect(page).to have_content('Farrapos')
    expect(page).to have_content('Porto Alegre')
    expect(page).to have_content('90250590')
    expect(page).to have_content('RS')
    expect(current_path).to eq event_places_path
  end

  it 'e falha devido aos campos obrigatórios estar em branco' do
    user = create(:user)
    login_as user

    visit dashboard_path
    within 'nav' do
      click_on 'Meus Locais'
    end

    click_on 'Novo Local'

    fill_in 'Nome', with: ''
    fill_in 'Rua', with: ''
    fill_in 'Número', with: ''
    fill_in 'Bairro', with: ''
    fill_in 'Cidade', with: ''
    fill_in 'CEP', with: ''
    select 'RS', from: 'Estado'
    click_on 'Cadastrar'

    expect(page).to have_content('Falha ao criar o Local de Evento')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Rua não pode ficar em branco')
    expect(page).to have_content('Número não pode ficar em branco')
    expect(page).to have_content('Bairro não pode ficar em branco')
    expect(page).to have_content('Cidade não pode ficar em branco')
    expect(page).to have_content('CEP não pode ficar em branco')
  end
end
