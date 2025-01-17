require 'rails_helper'

describe 'Usuário publica evento' do
    it 'e falha pois não está autenticado' do
        event = FactoryBot.create(:event)

        patch publish_event_path(event)

        expect(response).to redirect_to new_user_session_path
        expect(response).to have_http_status :found
    end

    it 'com sucesso' do
      user = FactoryBot.create(:user)
      event = FactoryBot.create(:event, user: user)

      login_as user

      patch publish_event_path(event)

      expect(response).to redirect_to event_path(event)
      expect(response).to have_http_status :found
  end
end
