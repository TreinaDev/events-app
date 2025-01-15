require 'rails_helper'

describe 'User tries to sign in' do
  it 'and gets to the correct page' do
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

  it 'and succeeds' do
    User.create(
      name: 'Luan',
      family_name: 'Carvalho',
      email: 'luan@email.com',
      password: 'fortissima12',
      password_confirmation: 'fortissima12',
      registration_number: CPF.generate
    )

    visit root_path
    click_on 'Entrar'

    fill_in 'E-mail', with: 'luan@email.com'
    fill_in 'Senha', with: 'fortissima12'
    within 'form' do
      click_on 'Entrar'
    end

    expect(current_path).to eq root_path
    expect(page).to have_button 'Sair'
    expect(page).to have_content 'Signed in successfully.'
    expect(page).not_to have_content 'Criar Conta'
  end

  it 'and fails when informing invalid data' do
    visit root_path
    click_on 'Entrar'

    fill_in 'E-mail', with: 'luan@email.com'
    fill_in 'Senha', with: 'fortissima12'
    within 'form' do
      click_on 'Entrar'
    end

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Invalid Email or password.'
  end
end
