require 'rails_helper'

describe 'Usuário visualiza detalhes do evento' do
    it 'e publica o evento' do
        user = FactoryBot.create(:user)
        event = FactoryBot.create(:event, user: user)

        login_as user

        visit event_path(event)
        click_on 'Publicar'

        expect(page).to have_content 'Evento publicado com sucesso.'
        expect(page).to have_content 'Publicado'
    end
end