require 'rails_helper'

describe 'Usuário tenta criar um comunicado' do
  it 'e falha por não estar autenticado' do
    event_manager = create(:user)
    event = create(:event, user: event_manager, status: :published)

    post event_announcements_path(event)

    expect(response).to redirect_to new_user_session_path
    expect(response.status).to eq 302
  end

  it 'e falha por ser um administrador' do
    event_manager = create(:user, role: :admin)
    event = create(:event, user: event_manager, status: :published)

    login_as event_manager
    post event_announcements_path(event)

    expect(response).to redirect_to dashboard_path
    expect(response.status).to eq 302
    follow_redirect!
    expect(response.body).to include('Acesso não autorizado')
  end
end
