require 'rails_helper'

describe 'Usuário visualiza a dashboard de gerenciador de evento' do
  it 'e nao esta autenticado' do
    event_manager = create(:user)
    event = create(:event, status: "published", user: event_manager)
    create(:ticket_batch, event: event)

    visit dashboard_path
    expect(page).not_to have_content "#{event.name}"
    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    event_manager = create(:user)
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


    login_as event_manager

    visit root_path

    expect(current_path).to eq dashboard_path
    first_event.reload
    second_event.reload
    expect(page).to have_content "Seu lucro total na plataforma: R$ 20.000,00"
    within "#created-events" do
      expect(page).to have_content "3"
      expect(page).to have_content "Eventos Criados"
    end
    within "#published-events" do
      expect(page).to have_content "2"
      expect(page).to have_content "Eventos Publicados"
    end
    expect(page).to have_content "Últimos Eventos Publicados"
    expect(page).to have_content "#{first_event.name}"
    expect(page).to have_content "#{second_event.name}"
  end
end
