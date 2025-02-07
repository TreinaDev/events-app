require 'rails_helper'

describe 'Usuário consegue ver as breadcrumbs' do
  it 'na página de listagem de verificações (como gerenciador de evento)' do
    user = create(:user)
    login_as user

    visit verifications_path

    expect(current_path).to eq verifications_path
    within "#breadcrumbs" do
      expect(page).to have_link "Home"
      expect(page).to have_content "Minhas Solicitações de Verificação"
    end
  end

  it 'na página de criar pedido de verificação (como gerenciador de evento)' do
    user = create(:user)
    login_as user

    visit new_verification_path

    expect(current_path).to eq new_verification_path
    within "#breadcrumbs" do
      expect(page).to have_link "Home"
      expect(page).to have_content "Nova Solicitação de Verificação"
    end
  end

  it 'na página de listagem de verificações (como admin)' do
    user = create(:user, :admin)
    login_as user

    visit verifications_path

    expect(current_path).to eq verifications_path
    within "#breadcrumbs" do
      expect(page).to have_link "Home"
      expect(page).to have_content "Solicitações de Verificação Pendentes"
    end
  end
end
