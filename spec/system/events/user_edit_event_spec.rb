require 'rails_helper'

describe 'Usuário tenta editar evento' do
  context 'em rascunho' do
    it 'com sucesso' do
      user = create(:user)
      category = create(:category, name: 'Tecnologia')
      create(:event, user: user, name: 'Introdução ao RoR', categories: [ category ])

      login_as user
      visit root_path
      within "nav#navbar" do
        click_on 'Meus Eventos'
      end
      click_on 'Gerenciar'
      click_on 'Editar'
      fill_in 'Nome', with: 'Rails Brasil'
      click_on 'Atualizar'

      expect(page).to have_content 'Evento atualizado com sucesso'
      expect(page).to have_content 'Rails Brasil'
      expect(page).not_to have_content 'Introdução ao RoR'
    end

    it 'falha ao salvar com campo obrigatório em branco' do
      user = create(:user)
      category = create(:category, name: 'Tecnologia')
      create(:event, user: user, name: 'Introdução ao RoR', categories: [ category ])

      login_as user
      visit root_path
      within "nav#navbar" do
        click_on 'Meus Eventos'
      end
      click_on 'Gerenciar'
      click_on 'Editar'
      fill_in 'Nome', with: ''
      click_on 'Atualizar'

      expect(page).to have_content 'Falha ao atualizar o Evento'
      expect(page).not_to have_content 'Rails Brasil'
    end
  end

  context 'publicado' do
    it 'e falha ao tentar editá-lo' do
      user = create(:user)
      category = create(:category, name: 'Tecnologia')
      create(:event, user: user, name: 'Introdução ao RoR', categories: [ category ], status: :published)

      login_as user
      visit root_path
      within "nav#navbar" do
        click_on 'Meus Eventos'
      end
      click_on 'Gerenciar'
      click_on 'Editar'
      fill_in 'Nome', with: 'Rails Brasil'
      click_on 'Atualizar'

      expect(page).to have_content 'Não é possível atualizar evento publicado'
      expect(page).not_to have_content 'Rails Brasil'
    end
  end

  it 'e não está autenticado' do
    user = create(:user)
    category = create(:category, name: 'Tecnologia')
    event = create(:event, user: user, name: 'Introdução ao RoR', categories: [ category ])

    visit edit_event_path(event)

    expect(current_path).to eq new_user_session_path
    expect(page).not_to have_content 'Edição de evento'
    expect(page).not_to have_content 'Introdução ao RoR'
    expect(page).not_to have_content 'Tecnologia'
  end
end
