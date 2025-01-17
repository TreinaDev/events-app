require 'rails_helper'

describe 'Usuário vê as categorias' do
  it 'e não está autenticado' do
    visit root_path

    expect(page).not_to have_content('Categoria')
    expect(current_path).to eq root_path
  end

  it 'e está autenticado, mas não é admnistrador' do
    user = create(:user, role: 'event_manager')
    login_as user

    visit root_path

    expect(page).not_to have_content('Categorias')
    expect(current_path).to eq root_path
  end

  it 'com sucesso' do
    user = create(:user, role: 'admin')
    Category.create!(name: 'Ruby')
    Category.create!(name: 'Rails')
    Category.create!(name: 'Culinária')

    login_as user
    visit root_path
    click_on 'Categorias'

    expect(page).to have_content('Lista de Categorias')
    expect(page).to have_content 'Ruby'
    expect(page).to have_content 'Rails'
    expect(page).to have_content 'Culinária'
    expect(current_path).to eq categories_path
  end

  it 'e não há nenhuma categoria cadastrada' do
    user = create(:user, role: 'admin')

    login_as user
    visit root_path
    click_on 'Categorias'

    expect(page).to have_content('Lista de Categorias')
    expect(page).to have_content('Nenhuma categoria cadastrada')
    expect(current_path).to eq categories_path
  end
end
