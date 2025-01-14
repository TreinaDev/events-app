require 'rails_helper'

describe 'Usuário vê as categorias' do
    it 'com sucesso' do
        # usuário logado
        Category.create!(name: 'Ruby')
        Category.create!(name: 'Rails')
        Category.create!(name: 'Culinária')

        visit root_path
        click_on 'Categorias'

        expect(page).to have_content('Lista de Categorias')
        expect(page).to have_content 'Ruby'
        expect(page).to have_content 'Rails'
        expect(page).to have_content 'Culinária'
        expect(current_path).to eq categories_path
    end

  ## Teste para quando não há categorias cadastradas
  it 'e não há nenhuma categoria cadastrada' do
    # usuário logado
    visit root_path
    click_on 'Categorias'

    expect(page).to have_content('Lista de Categorias')
    expect(page).to have_content('Nenhuma categoria cadastrada')
    expect(current_path).to eq categories_path
  end
end
