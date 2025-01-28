require 'rails_helper'

describe 'Usuário tenta fazer cadastro' do
  it 'e conclui com sucesso quando cadastrando organizador de evento' do
    visit root_path
    click_on 'Criar Conta'

    fill_in 'Nome', with: 'Luan'
    fill_in 'Sobrenome', with: 'Carvalho'
    fill_in 'E-mail', with: 'luan@email'
    fill_in 'Senha', with: 'fortissima12'
    fill_in 'Confirme sua senha', with: 'fortissima12'
    fill_in 'CPF', with: CPF.generate
    within 'form' do
      click_on 'Criar Conta'
    end

    expect(current_path).to eq dashboard_path
    expect(page).to have_button 'Sair'
    expect(page).to have_content 'Bem vindo! Você realizou seu registro com sucesso.'
    expect(page).not_to have_content 'Criar Conta'
  end

  it 'e conclui com sucesso, enviando email de confirmação, quando cadastrando usuário admin' do
    visit root_path

    click_on 'Criar Conta'
    fill_in 'Nome', with: 'Luan'
    fill_in 'Sobrenome', with: 'Carvalho'
    fill_in 'E-mail', with: 'luan@meuevento.com.br'
    fill_in 'Senha', with: 'fortissima12'
    fill_in 'Confirme sua senha', with: 'fortissima12'
    fill_in 'CPF', with: CPF.generate
    within 'form' do
      click_on 'Criar Conta'
    end

    last_user = User.last
    expect(last_user.confirmed?).to eq false
    expect(last_user.confirmation_sent_at).not_to eq nil
    expect(page).to have_content 'Uma mensagem com um link de confirmação foi enviada para o seu e-mail. Por favor, acesse o link para ativar sua conta.'
  end

  it 'e falha quando informa algum dado inválido' do
    visit root_path
    click_on 'Criar Conta'

    fill_in 'Nome', with: 'Luan'
    fill_in 'Sobrenome', with: 'Carvalho'
    fill_in 'E-mail', with: 'luan@email'
    fill_in 'Senha', with: 'fortissima12'
    fill_in 'Confirme sua senha', with: 'fortissima12'
    fill_in 'CPF', with: '00000000000'
    within 'form' do
      click_on 'Criar Conta'
    end

    expect(User.count).to eq 0
    expect(page).to have_content 'Criar Minha Conta'
    expect(page).to have_content 'CPF Não é um CPF válido'
  end
end
