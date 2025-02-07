require 'rails_helper'

describe 'Usuário visualiza detalhes do evento' do
    it 'e não está autenticado' do
        user = create(:user)
        event = create(:event, user: user)

        visit event_path(event)

        expect(page).to have_content 'Para continuar, faça login ou registre-se.'
    end

    it 'e não consegue pois não é dono do evento' do
        user = create(:user)
        second_user = create(:user, email: 'joao@email.com')
        event = create(:event, user: user)

        login_as second_user

        visit event_path(event)

        expect(page).to have_content 'Acesso não autorizado.'
    end

    it 'e publica o evento' do
        user = create(:user)
        event = create(:event, user: user)

        login_as user

        visit event_path(event)
        click_on 'Publicar'

        expect(page).to have_content 'Evento publicado com sucesso.'
        expect(page).to have_content 'Publicado'
    end

    it 'com sucesso um evento em rascunho' do
      user = create(:user)
      event = create(:event, user: user)
      login_as user


      visit event_path(event)

      expect(page).to have_content "Site do Evento: #{event.url}"
      expect(page).to have_content "Endereço: #{event.address}"
      expect(page).to have_content "#{event.description.body.to_html}"
      expect(page).to have_content "Limite de Participantes: #{event.participants_limit}"
      expect(page).to have_content "Status: #{Event.human_enum_name(:status, event.status)}"
    end

    it 'com sucesso um evento publicado' do
      user = create(:user)
      event = create(:event, user: user, status: "published")
      create(:ticket_batch, event: event)
      response_json = {
        id: 1,
        sold_tickets: 15,
        participants: []
      }
      allow(ParticipantsApiService).to receive(:get_participants_and_tickets_by_event_code).and_return(response_json)
      login_as user


      visit event_path(event)

      expect(page).to have_content "Site do Evento: #{event.url}"
      expect(page).to have_content "Endereço: #{event.address}"
      expect(page).to have_content "#{event.description.body.to_html}"
      expect(page).to have_content "Participantes: #{event.participants_count} / #{event.participants_limit}"
      expect(page).to have_content "Status: #{Event.human_enum_name(:status, event.status)}"
    end
end
