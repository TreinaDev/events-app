require 'rails_helper'

describe 'Usuário revisa verificação' do
  it 'e falha por não estar autenticado' do
    user = create(:user, :with_pending_request)

    patch verification_review_path(user.verifications.first)

    expect(response).to redirect_to new_user_session_path
    expect(response).to have_http_status :found
  end

  it 'e falha por não ser administrador' do
    user = create(:user, :with_pending_request)
    second_user = create(:user, name: 'Gabriel', email: 'gabriel@email.com')

    login_as second_user

    patch verification_review_path(user.verifications.first), params: {  verification: { comment: '' }, status: "approved" }

    expect(response).to redirect_to dashboard_path
    expect(response).to have_http_status :found
    follow_redirect!
    expect(response.body).to include('Você não tem autorização para acessar essa página.')
  end

  it 'e falha pois requisição já foi analisada' do
    user = create(:user, :with_pending_request)
    second_user = create(:user, name: 'Gabriel', email: 'gabriel@email.com', role: 'admin')
    user.verifications.first.update(status: 'approved')

    login_as second_user

    patch verification_review_path(user.verifications.first), params: {  verification: { comment: 'Foto do documento não está legível.' }, status: "rejected" }

    expect(response).to redirect_to user.verifications.first
    expect(response).to have_http_status :found
    follow_redirect!
    expect(response.body).to include('Requisição já foi analisada.')
    expect(response.body).to include('Aprovada')
  end

  it 'e falha por não enviar dados necessários' do
    user = create(:user, :with_pending_request)
    second_user = create(:user, name: 'Gabriel', email: 'gabriel@email.com', role: 'admin')

    login_as second_user

    patch verification_review_path(user.verifications.first), params: {  verification: { comment: '' }, status: "" }

    expect(response).to have_http_status :unprocessable_entity
  end

  it 'e falha pois não forneceu um comentário em caso de reprovação' do
    user = create(:user, :with_pending_request)
    second_user = create(:user, name: 'Gabriel', email: 'gabriel@email.com', role: 'admin')

    login_as second_user

    patch verification_review_path(user.verifications.first), params: {  verification: { comment: '' }, status: "rejected" }

    expect(response).to have_http_status :unprocessable_entity
  end

  it 'com sucesso' do
    user = create(:user, :with_pending_request)
    second_user = create(:user, name: 'Gabriel', email: 'gabriel@email.com', role: 'admin')

    login_as second_user

    patch verification_review_path(user.verifications.first), params: {  verification: { comment: 'Foto do documento não está legível.' }, status: "rejected" }

    expect(response).to redirect_to user.verifications.first
    expect(response).to have_http_status :found
    follow_redirect!
    expect(response.body).to include('Foto do documento não está legível.')
    expect(response.body).to include('Rejeitada')
  end
end
