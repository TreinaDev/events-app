require 'rails_helper'

describe 'Usuário vê detalhes de uma verificação' do
  it 'e falha por não estar autenticado' do
    user = create(:user, :with_pending_request)

    visit verification_path(user.verifications.first)

    expect(current_path).to eq new_user_session_path
  end

  it 'e não vê formulário de avaliação pois é um usuário gerenciador de eventos' do
    user = create(:user, :with_pending_request)

    login_as user

    visit verification_path(user.verifications.first)

    expect(page).not_to have_selector '#verification-form'
    expect(page).not_to have_content 'Analisar verificação'
  end

  it 'e vê formulário de avaliação pois é um usuário administrador' do
    user = create(:user, :with_pending_request)
    admin = create(:user, role: :admin, email: 'gabriel@email.com')

    login_as admin

    visit verification_path(user.verifications.first)

    expect(page).to have_selector '#verification-form'
    expect(page).to have_content 'Analisar verificação'
  end

  it 'com sucesso' do
    user = create(:user, :with_pending_request, name: 'Gabriel', family_name: 'Toledo', email: 'gabriel@email.com', phone_number: '35 99988 7766')

    login_as user

    visit root_path
    click_on 'Consultar reqs. de verificação'
    click_on 'Solicitação #1'

    save_page

    expect(page).to have_content 'Gabriel'
    expect(page).to have_content 'Toledo'
    expect(page).to have_content 'gabriel@email.com'
    expect(page).to have_content CPF.new(user.registration_number).formatted
    expect(page).to have_content 'Status atual: Pendente'
    expect(page).to have_content '35 99988 7766'
    expect(page).to have_content 'Rua das Laranjeiras'
    expect(page).to have_content 'Laranjeiras'
  end

  it 'como um usuário administrador e faz uma avaliação da requisição com sucesso' do
    user = create(:user, :with_pending_request, name: 'Gabriel', email: 'gabriel@email.com')
    admin = create(:user, role: :admin, email: 'samuel@email.com', name: 'Samuel')

    login_as admin

    visit verification_path(user.verifications.first)

    within '#verification-form' do
      fill_in 'Comentário', with: 'Foto do documento não está legível.'
      click_on 'Reprovar'
    end

    expect(page).to have_content 'Status atual: Rejeitada'
    expect(page).to have_content 'Comentário da análise: Foto do documento não está legível.'
    expect(page).not_to have_selector '#verification-form'
    expect(page).not_to have_content 'Analisar verificação'
  end
end
