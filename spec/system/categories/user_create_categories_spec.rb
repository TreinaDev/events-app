require 'rails_helper'

describe 'Usuário cadastra as categorias' do
    it 'com sucesso' do
        # usuário logado
        visit root_path
        click_on 'Categorias'
        click_on 'Nova Categoria'

        fill_in "Nome",	with: "Ruby"
        click_on 'Criar Categoria'

        expect(page).to have_content('Lista de Categorias')
        expect(page).to have_content('Ruby')
        expect(page).to have_content('Categoria adicionada com sucesso.')
        expect(current_path).to eq categories_path
    end

    it 'e falha porque o nome está em branco' do
        # usuário logado
        visit root_path
        click_on 'Categorias'
        click_on 'Nova Categoria'

        fill_in "Nome",	with: ""
        click_on 'Criar Categoria'

        expect(page).to have_content('Nova Categoria')
        expect(page).to have_content('Categoria não foi adicionada.')
        expect(current_path).to eq new_category_path
    end
end
