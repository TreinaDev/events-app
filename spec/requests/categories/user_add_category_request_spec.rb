require 'rails_helper'

describe 'Usuário cadastra categorias' do
  it 'e falha por não estar autenticado' do
    get(new_category_path)

    expect(response).to redirect_to new_user_session_path
    expect(response.status).to eq 302
  end
end
