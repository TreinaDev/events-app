require 'rails_helper'

describe 'Usuario tenta criar uma palavra-chave' do
  it 'e falha por não está autenticado' do
    post keywords_path(params: { keyword: { value: 'Backend' } })

    expect(response).to redirect_to new_user_session_path
    expect(response).to have_http_status :found
  end

  it 'e falha por não ter permissao' do
    user = create(:user)
    login_as user
    post keywords_path(params: { keyword: { value: 'Backend' } })

    expect(response).to redirect_to dashboard_path
    expect(response).to have_http_status :found
  end

  it 'e consegue com sucesso' do
    user = create(:user, :admin)
    login_as user
    post keywords_path(params: { keyword: { value: 'Backend' } })

    expect(response).to redirect_to categories_path
    expect(response).to have_http_status :found
  end
end
