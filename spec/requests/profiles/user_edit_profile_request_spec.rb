require 'rails_helper'

describe 'Usuário edita evento:' do
  it 'e falha pois não está autenticado' do
    create(:user)

    patch profile_path

    expect(response).to redirect_to(new_user_session_path)
    expect(response.status).to eq 302
  end

  it 'com sucesso' do
    user = create(:user, verification_status: :verified)
    login_as user

    patch profile_path, params: { user: { name: 'Novo Nome' } }

    expect(response).to have_http_status :redirect
    follow_redirect!
    expect(response.body).to include('Perfil atualizado com sucesso.')
    expect(response.status).to eq 200
  end
end
