require 'rails_helper'

describe 'Visitante abre a app', type: :system do
  it 'com sucesso' do
    visit root_path
    expect(page).to have_content 'Transforme suas ideias em eventos incríveis de tecnologia com a E-ventos!'
    expect(page).to have_content 'Cadastre-se e comece a criar eventos agora'
    expect(page).to have_link 'Entrar'
    expect(page).to have_link 'Criar Conta'
  end

  context 'como administrador' do
    it 'E não tem opção de criar evento' do
      admin = create(:user, role: :admin)

      login_as admin
      visit root_path

      expect(page).not_to have_link 'Criar evento'
    end
  end
end
