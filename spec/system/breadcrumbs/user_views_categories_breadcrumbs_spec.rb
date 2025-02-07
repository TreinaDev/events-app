require 'rails_helper'

describe 'Usuário consegue ver as breadcrumbs' do
  it 'na página de listagem de categorias' do
    user = create(:user, :admin)
    create(:category)
    login_as user

    visit categories_path

    expect(current_path).to eq categories_path
    within "#breadcrumbs" do
      expect(page).to have_link "Home"
      expect(page).to have_content "Categorias"
    end
  end

  it 'na página de criar categoria' do
    user = create(:user, :admin)
    login_as user

    visit new_category_path

    expect(current_path).to eq new_category_path
    within "#breadcrumbs" do
      expect(page).to have_link "Home"
      expect(page).to have_link "Categorias"
      expect(page).to have_content "Nova Categoria"
    end
  end

  it 'na página de detalhes de uma categoria' do
    user = create(:user, :admin)
    category = create(:category)
    login_as user

    visit category_path(category)

    expect(current_path).to eq category_path(category)
    within "#breadcrumbs" do
      expect(page).to have_link "Home"
      expect(page).to have_link "Categorias"
      expect(page).to have_content "#{category.name}"
    end
  end
end
