require 'rails_helper'

describe 'Usuário tenta fazer cadastro' do
  it 'e conclui com sucesso' do
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

  it 'e falha quando informa algum dado inválido' do
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
end
