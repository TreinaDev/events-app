require 'rails_helper'

describe 'Usuario associa uma palavra-chave à uma categoria' do
  it 'e falha por não estar autenticado' do
    category = create(:category)
    keyword = create(:keyword)

    patch category_path(category), params: { category: { keyword_ids: [ keyword.id ] } }

    expect(response).to have_http_status(:redirect)
    expect(response).to redirect_to(new_user_session_path)
    expect(category.keywords).to be_empty
  end

  it 'e falha por não estar autorizado' do
    category = create(:category)
    keyword = create(:keyword)
    user = create(:user)
    login_as user

    patch category_path(category), params: { category: { keyword_ids: [ keyword.id ] } }

    expect(response).to have_http_status(:redirect)
    expect(response).to redirect_to(dashboard_path)
    expect(category.keywords).to be_empty
  end
end
