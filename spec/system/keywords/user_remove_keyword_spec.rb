require 'rails_helper'

describe 'Usuário remove associação de palavra-chave' do
  context 'à uma categoria já existente' do
    it 'com sucesso' do
      user = create(:user, :admin)
      ruby = FactoryBot.create(:category, name: 'Ruby')
      backend = FactoryBot.create(:keyword, value: 'Backend')
      CategoryKeyword.create(category: ruby, keyword: backend)
      login_as user

      visit category_path(ruby)
      uncheck 'Backend'
      click_on 'Atualizar'

      expect(page).to have_content 'Categoria atualizada com sucesso.'
      within "##{ruby.name}" do
        expect(page).not_to have_content 'Backend'
      end
    end
  end
end
