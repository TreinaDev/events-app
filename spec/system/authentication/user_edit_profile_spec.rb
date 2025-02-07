require 'rails_helper'

describe 'Usuário edita o seu perfil:' do
  context 'Sendo administrador' do
    it 'e falha por não preencher adequadamente' do
      admin = create(:user, role: :admin, name: 'Goulart')
      login_as admin

      visit root_path
      click_on 'Goulart'
      click_on 'Editar'
      fill_in 'Nome', with: ''
      fill_in 'Sobrenome', with: ''
      click_on 'Concluir'

      expect(page).to have_content 'Sobrenome não pode ficar em branco'
      expect(page).to have_content 'Nome não pode ficar em branco'
      expect(page).to have_content 'Perfil não foi atualizado.'
    end

    it 'com sucesso' do
      admin = create(:user, role: :admin, name: 'Goulart')
      login_as admin

      visit root_path
      click_on 'Goulart'
      click_on 'Editar'
      fill_in 'Nome', with: 'Guimarães'
      attach_file('Foto de Perfil', Rails.root.join('spec/support/images/logo.png'))
      click_on 'Concluir'

      expect(page).to have_content 'Guimarães'
      expect(page).not_to have_content 'Goulart'
      expect(page).to have_content 'Perfil atualizado com sucesso.'
    end
  end

  context 'Sendo organizador' do
    it 'e falha por não ser verificado' do
      event_manager = create(:user, verification_status: :unverified, name: 'Goulart')
      login_as event_manager

      visit root_path
      click_on 'Goulart'
      click_on 'Editar'

      expect(current_path).to eq profile_path
      expect(page).not_to have_button 'Concluir'
      expect(page).to have_content 'Apenas usuários verificados podem atualizar o perfil'
    end

    it 'e falha por ter verificação pendente' do
      event_manager = create(:user, verification_status: :pending, name: 'Goulart')
      login_as event_manager

      visit root_path
      click_on 'Goulart'
      click_on 'Editar'

      expect(current_path).to eq profile_path
      expect(page).not_to have_button 'Concluir'
      expect(page).to have_content 'Apenas usuários verificados podem atualizar o perfil'
    end

    it 'e falha por não preencher adequadamente' do
      event_manager = create(:user, verification_status: :verified, name: 'Goulart')
      login_as event_manager

      visit root_path
      click_on 'Goulart'
      click_on 'Editar'
      fill_in 'Nome', with: ''
      fill_in 'Sobrenome', with: ''
      click_on 'Concluir'

      expect(page).to have_content 'Sobrenome não pode ficar em branco'
      expect(page).to have_content 'Nome não pode ficar em branco'
      expect(page).to have_content 'Perfil não foi atualizado.'
    end

    it 'com sucesso' do
      event_manager = create(:user, verification_status: :verified, name: 'Goulart')
      login_as event_manager

      visit root_path
      click_on 'Goulart'
      click_on 'Editar'
      fill_in 'Nome', with: 'Guimarães'
      attach_file('Foto de Perfil', Rails.root.join('spec/support/images/logo.png'))
      click_on 'Concluir'

      expect(page).to have_content 'Guimarães'
      expect(page).not_to have_content 'Goulart'
      expect(page).to have_content 'Perfil atualizado com sucesso.'
    end
  end
end
