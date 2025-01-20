require 'rails_helper'

describe 'Usuário visualiza detalhes do evento' do
    it 'e não está autenticado' do
        user = FactoryBot.create(:user)
        event = FactoryBot.create(:event, user: user)

        visit event_path(event)

        expect(page).to have_content 'Para continuar, faça login ou registre-se.'
    end

    it 'e não consegue pois não é dono do evento' do
        user = FactoryBot.create(:user)
        second_user = FactoryBot.create(:user, email: 'joao@email.com')
        event = FactoryBot.create(:event, user: user)

        login_as second_user

        visit event_path(event)

        expect(page).to have_content 'Acesso não autorizado.'
    end

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
