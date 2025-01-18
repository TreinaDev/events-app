require 'rails_helper'
describe 'Usuário tenta fazer login e acessar a página interna' do
  it 'e consegue com sucesso' do
    user = create(:user, email: 'luan@email.com', password: 'password123')

    visit new_user_session_path
    fill_in 'E-mail', with: user.email
    fill_in 'Senha', with: user.password
    within 'form' do
      click_on 'Entrar'
    end

    expect(current_path).to eq dashboard_path
  end
end
