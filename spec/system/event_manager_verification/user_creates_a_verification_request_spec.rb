require 'rails_helper'

describe 'Usuário não verificado visita a tela de criar solicitação de verificação' do
  it 'e não está autenticado' do
    visit new_verification_path

    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'e está autenticado' do
    user = create(:user)

    login_as user

    visit new_verification_path

    expect(page).to have_content 'Nova Requisição de Verificação'
  end

  it 'e conclui com sucesso' do
    user = create(:user)
    login_as user

    visit root_path
    within "[data-controller='user-options']" do
      click_on 'Requisitar verificação'
    end
    fill_in 'Número de Telefone', with: '11999887766'
    within '#address_form' do
      fill_in 'Rua', with: 'Rua Judite dos Santos'
      fill_in 'Número', with: '522'
      fill_in 'Bairro', with: 'Centro'
      fill_in 'Cidade', with: 'São Paulo'
      select 'SP', from: 'Estado'
      fill_in 'CEP', with: '01000-000'
    end
    attach_file('Foto/Arquivo do Documento de Identificação', Rails.root.join('spec/support/images/id_photo.png'))
    attach_file('Foto/Arquivo do Comprovante de Residência', Rails.root.join('spec/support/images/address_proof.jpeg'))
    click_on 'Requisitar Validação'

    expect(page).to have_content('Sua requisição de análise do perfil foi criada com sucesso! Aguarde pela validação por um administrador')
    expect(user.reload.verification_status).to eq "pending"
    expect(Verification.last.status).to eq "pending"
    expect(current_path).to eq dashboard_path
  end

  it 'e falha por enviar algum dado inválido' do
    user = create(:user)
    login_as user

    visit root_path
    within "[data-controller='user-options']" do
      click_on 'Requisitar verificação'
    end
    fill_in 'Número de Telefone', with: '11999887766'
    within '#address_form' do
      fill_in 'Rua', with: 'Rua Judite dos Santos'
      fill_in 'Número', with: '522.5'
      fill_in 'Bairro', with: 'Centro'
      fill_in 'Cidade', with: 'São Paulo'
      select 'SP', from: 'Estado'
      fill_in 'CEP', with: '01000-000'
    end
    attach_file('Foto/Arquivo do Documento de Identificação', Rails.root.join('spec/support/images/id_photo.png'))
    attach_file('Foto/Arquivo do Comprovante de Residência', Rails.root.join('spec/support/images/address_proof.jpeg'))
    click_on 'Requisitar Validação'

    expect(page).to have_content('Erro ao enviar requisição de análise do perfil')
    expect(page).to have_content('Número não é um número inteiro')
  end
end
