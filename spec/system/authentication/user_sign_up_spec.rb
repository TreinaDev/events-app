require 'rails_helper'

describe 'User tries to sign up' do
  it 'and gets to the correct page' do
    visit root_path
    click_on 'Criar Conta'

    expect(current_path).to eq new_user_registration_path
    expect(page).to have_content "Criar Minha Conta"
    expect(page).to have_selector 'form'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Sobrenome'
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Senha'
    expect(page).to have_field 'CPF'
    expect(page).to have_button 'Criar Conta'
  end

  it 'and succeeds' do
    visit root_path
    click_on 'Criar Conta'

    fill_in 'Nome', with: 'Luan'
    fill_in 'Sobrenome', with: 'Carvalho'
    fill_in 'E-mail', with: 'luan@email'
    fill_in 'Senha', with: 'fortissima12'
    fill_in 'Confirmar Senha', with: 'fortissima12'
    fill_in 'CPF', with: CPF.generate
    within 'form' do
      click_on 'Criar Conta'
    end

    expect(current_path).to eq root_path
    expect(page).to have_button 'Sair'
    expect(page).to have_content 'Bem vindo! Você realizou seu registro com sucesso.'
    expect(page).not_to have_content 'Criar Conta'
  end

  it 'and fails when informing invalid data' do
    visit root_path
    click_on 'Criar Conta'

    fill_in 'Nome', with: 'Luan'
    fill_in 'Sobrenome', with: 'Carvalho'
    fill_in 'E-mail', with: 'luan@email'
    fill_in 'Senha', with: 'fortissima12'
    fill_in 'Confirmar Senha', with: 'fortissima12'
    fill_in 'CPF', with: '00000000000'
    within 'form' do
      click_on 'Criar Conta'
    end

    expect(current_path).to eq new_user_registration_path
    expect(page).to have_content 'Criar Conta'
    expect(page).to have_content 'CPF Não é um CPF válido'
  end

  it 'and fails when informing invalid data' do
    visit root_path
    click_on 'Criar Conta'

    fill_in 'Nome', with: ''
    fill_in 'Sobrenome', with: ''
    fill_in 'E-mail', with: ''
    fill_in 'Senha', with: ''
    fill_in 'Confirmar Senha', with: ''
    fill_in 'CPF', with: ''
    within 'form' do
      click_on 'Criar Conta'
    end

    expect(current_path).to eq new_user_registration_path
    expect(page).to have_content 'Criar Conta'
    expect(page).to have_content "Sobrenome não pode ficar em branco"
    expect(page).to have_content "Nome não pode ficar em branco"
    expect(page).to have_content "E-mail não pode ficar em branco"
    expect(page).to have_content "Senha não pode ficar em branco"
    expect(page).to have_content "CPF não pode ficar em branco"
    expect(page).to have_content 'CPF Não é um CPF válido'
  end
end
