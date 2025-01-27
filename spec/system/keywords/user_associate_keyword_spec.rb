require 'rails_helper'

describe 'Usuário associa uma palavra-chave' do
  context 'à uma categoria já existente' do
    it 'e não tá autorizado' do
      ruby = create(:category)
      user = create(:user)
      login_as user

      visit category_path(ruby)

      expect(page).to have_content 'Você não tem autorização para acessar essa página.'
      expect(current_path).to eq dashboard_path
    end

    it 'com sucesso' do
      ruby = create(:category, name: 'Ruby')
      user = create(:user, :admin)
      programacao = create(:keyword, value: 'Programação')
      CategoryKeyword.create!(category: ruby, keyword: programacao)
      create(:keyword, value: 'Frontend')
      create(:keyword, value: 'Backend')
      login_as user

      visit category_path(ruby)
      check 'Backend'
      click_on 'Atualizar'

      expect(page).to have_content 'Categoria atualizada com sucesso.'
      expect(current_path).to eq categories_path
      within "##{ruby.name}" do
        expect(page).to have_content 'Palavras-Chave:'
        expect(page).to have_content 'Backend'
        expect(page).to have_content 'Programação'
      end
      expect(page).not_to have_content 'Frontend'
    end

    it 'teste de falha' do
      ruby = create(:category, name: 'Ruby')
      user = create(:user, :admin)
      login_as user

      visit category_path(ruby)

      expect(page).to have_content 'Não há palavras-chave disponíveis para associar.'
    end
  end
end
