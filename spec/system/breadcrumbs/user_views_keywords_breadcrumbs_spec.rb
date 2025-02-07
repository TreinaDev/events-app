require 'rails_helper'

describe 'Usuário consegue ver as breadcrumbs' do
  it 'na página de criar palavras-chave' do
    user = create(:user, :admin)
    login_as user

    visit new_keyword_path

    expect(current_path).to eq new_keyword_path
    within "#breadcrumbs" do
      expect(page).to have_link "Home"
      expect(page).to have_link "Categorias"
      expect(page).to have_content "Cadastrar Palavra-Chave"
    end
  end
end
