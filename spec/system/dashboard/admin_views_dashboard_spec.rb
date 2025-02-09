require 'rails_helper'

describe 'Usuário visualiza a dashboard de administrador' do
  it 'e nao esta autenticado' do
    visit dashboard_path

    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    event_manager = create(:user)
    create(:user, :with_pending_request, name: "Sidnei", family_name: "Coquinho", email: 'gabriel@email.com')
    admin = create(:user, role: :admin, email: 'samuel@email.com', name: 'Samuel')
    first_event = create(:event, status: "published", user: event_manager)
    create(:ticket_batch, event: first_event)

    second_event = create(:event, name: "Segundo Evento", status: "published", user: event_manager, categories: [ Category.first ])
    create(:ticket_batch, event: second_event)
    create(:ticket_batch, event: second_event)

    third_event = create(:event, user: event_manager, categories: [ Category.first ])
    create(:ticket_batch, event: third_event)

    event_participants_count_response = { id: 1, participants: [], sold_tickets: 2 }
    second_event_participants_count_response = { id: 1, participants: [], sold_tickets: 4 }
    allow(ParticipantsApiService).to receive(:get_participants_and_tickets_by_event_code).and_return(
      event_participants_count_response,
      second_event_participants_count_response
    )


    login_as admin

    visit root_path

    expect(current_path).to eq dashboard_path
    first_event.reload
    second_event.reload
    within "#events-stats" do
      expect(page).to have_content "3"
      expect(page).to have_content "eventos criados"
      expect(page).to have_content "2"
      expect(page).to have_content "eventos publicados"
    end
    within "#users-stats" do
      expect(page).to have_content "2"
      expect(page).to have_content "usuários cadastrados"
      expect(page).to have_content "0"
      expect(page).to have_content "usuários verificados"
      expect(page).to have_content "5"
      expect(page).to have_content "verificações pendentes"
      expect(page).to have_content "Solicitação de Sidnei Coquinho"
    end
  end
end
