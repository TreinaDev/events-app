require 'rails_helper'

describe 'Usuário consegue ver as breadcrumbs' do
  it 'na página de detalhes do perfil' do
    user = create(:user, verification_status: "verified")
    login_as user

    visit profile_path

    expect(current_path).to eq profile_path
    within "#breadcrumbs" do
      expect(page).to have_link "Home"
      expect(page).to have_content "Meu Perfil"
    end
  end

  it 'na página de editar perfil' do
    user = create(:user, verification_status: "verified")
    login_as user

    visit edit_profile_path

    expect(current_path).to eq edit_profile_path
    within "#breadcrumbs" do
      expect(page).to have_link "Home"
      expect(page).to have_link "Meu Perfil"
      expect(page).to have_content "Editar Perfil"
    end
  end
end
