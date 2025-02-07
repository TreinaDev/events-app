require 'rails_helper'

describe 'Usuário publica evento' do
    it 'e falha pois não está autenticado' do
        event = create(:event)

        patch publish_event_path(event)

        expect(response).to redirect_to new_user_session_path
        expect(response).to have_http_status :found
    end

    it 'e falha pois o evento é do outro usuário' do
        user = create(:user)
        second_user = create(:user, email: 'joao@email.com')
        event = create(:event, user: user)

        login_as second_user

        patch publish_event_path(event)

        expect(response).to redirect_to root_path
        expect(response).to have_http_status :found
    end

    it 'com sucesso' do
      user = create(:user)
      event = create(:event,
        user: user,
        logo: File.open(Rails.root.join('spec/support/images/logo.jpg'), filename: 'logo.jpg'),
        banner: File.open(Rails.root.join('spec/support/images/banner.png'), filename: 'banner.png')
      )

      login_as user

      patch publish_event_path(event)

      expect(response).to redirect_to event_path(event)
      expect(response).to have_http_status :found
      expect(event.reload.status).to eq "published"
  end

  it 'falha pois não possue imagem (obrigatório ao publicar)' do
    user = create(:user)
    event = create(:event, user: user, status: :draft, banner: nil, logo: nil)

    login_as user

    patch publish_event_path(event)

    expect(response).to have_http_status :unprocessable_entity
    expect(event.reload.status).to eq "draft"
    expect(response.body).to include "Banner e Logo são obrigatórios ao publicar um Evento."
  end
end
