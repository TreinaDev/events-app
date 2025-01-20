require 'rails_helper'

describe 'Usuário tenta fazer login' do
  it 'e chega na página correta' do
    visit root_path
    click_on 'Entrar'

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content "Log in"
    expect(page).to have_selector 'form'
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Senha'

    within 'form' do
      expect(page).to have_button 'Entrar'
    end
  end

  it 'e conclui com sucesso' do
    create(:user, email: 'luan@email.com', password: 'password123')

    visit root_path
    click_on 'Entrar'

    fill_in 'E-mail', with: 'luan@email.com'
    fill_in 'Senha', with: 'password123'
    within 'form' do
      click_on 'Entrar'
    end

    expect(current_path).to eq dashboard_path
    expect(page).to have_button 'Sair'
    expect(page).to have_content 'Login efetuado com sucesso.'
    expect(page).not_to have_content 'Criar Conta'
  end

  it 'e falha quando informa algum dado inválido' do
    visit root_path
    click_on 'Entrar'

    fill_in 'E-mail', with: 'luan@email.com'
    fill_in 'Senha', with: 'fortissima12'
    within 'form' do
      click_on 'Entrar'
    end

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'E-mail ou senha inválidos.'
  end
end
