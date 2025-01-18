require 'rails_helper'

describe 'Usuário tenta acessar root path apos estar logado' do
  it 'e é redirecionado para a dashboard' do
    user = create(:user)
    login_as user

    get root_path

    expect(response).to redirect_to dashboard_path
  end
end
