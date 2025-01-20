require 'rails_helper'

describe 'Usuário cadastra categorias' do
  it 'e falha por não estar autenticado' do
    get(new_category_path)

    expect(response).to redirect_to new_user_session_path
    expect(response.status).to eq 302
  end

  it 'e falha por não ser adminstrador' do
    user = create(:user, role: 'event_manager')
    login_as user

    get(new_category_path)

    expect(response).to redirect_to dashboard_path
    expect(response.status).to eq 302
    follow_redirect!
    expect(response.body).to include('Você não tem autorização para acessar essa página.')
  end

  it 'com sucesso' do
    user = create(:user, role: 'admin')
    login_as user

    get(new_category_path)

    expect(response.status).to eq 200
  end
end
