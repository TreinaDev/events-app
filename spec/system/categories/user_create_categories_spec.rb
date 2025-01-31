require 'rails_helper'

describe 'Usuário cadastra as categorias' do
    it 'com sucesso' do
        user = create(:user, role: 'admin')
        login_as user

        visit root_path
        click_on 'Categorias'
        click_on '+ Categoria'
        fill_in "Nome",	with: "Ruby"
        click_on 'Criar Categoria'

        expect(page).to have_content('Categorias Cadastradas')
        expect(page).to have_content('Ruby')
        expect(page).to have_content('Categoria adicionada com sucesso.')
        expect(current_path).to eq categories_path
    end

    it 'e falha porque o nome está em branco' do
        user = create(:user, role: 'admin')
        login_as user

        visit root_path
        click_on 'Categorias'
        click_on '+ Categoria'
        fill_in "Nome",	with: ""
        click_on 'Criar Categoria'

        expect(page).to have_content('Nova Categoria')
        expect(page).to have_content('Nome não pode ficar em branco')
        expect(Category.count).to eq 0
    end

    it 'e falha porque o nome já está cadastrado' do
        create(:category, name: 'Culinária')
        user = create(:user, role: 'admin')
        login_as user

        visit root_path
        click_on 'Categorias'
        click_on '+ Categoria'
        fill_in "Nome",	with: "Culinária"
        click_on 'Criar Categoria'

        expect(page).to have_content('O nome dessa categoria já está em uso')
        expect(page).to have_content('Categoria não foi adicionada.')
        expect(Category.count).to eq 1
    end
end
