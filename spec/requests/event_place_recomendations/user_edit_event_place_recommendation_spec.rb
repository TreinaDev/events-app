require 'rails_helper'

describe 'Usuário edita recomendação de lugar de evento' do
  it 'com sucesso' do
    user = create(:user)
    event_place = create(:event_place, user: user)
    recommendation = create(:event_place_recommendation, event_place: event_place, name: 'Area 1', full_address: 'Rua do povo 123', phone: '51999999999')
    login_as user

    patch event_place_recommendation_path(event_place, recommendation), params: {
      event_place_recommendation: {
        name: 'Area 2',
        full_address: 'Rua Nova 456',
        phone: '51988888888'
      }
    }

    expect(response).to redirect_to(event_place_path(event_place))
    follow_redirect!

    expect(response.body).to include('Recomendação de Local atualizada com sucesso.')
    expect(response.body).to include('Area 2')
    expect(response.body).to include('Rua Nova 456')
  end

  it 'e falha ao tentar editar sem estar autenticado' do
    user = create(:user)
    event_place = create(:event_place, user: user)
    recommendation = create(:event_place_recommendation, event_place: event_place)

    patch event_place_recommendation_path(event_place, recommendation), params: {
      event_place_recommendation: {
        name: 'Area 2',
        full_address: 'Rua Nova 456',
        phone: '51988888888'
      }
    }

    expect(response).to redirect_to(new_user_session_path)
    expect(response.status).to eq 302
  end

  it 'e falha ao tentar editar recomendação de outro usuário' do
    user = create(:user)
    event_place = create(:event_place, user: user)
    recommendation = create(:event_place_recommendation, event_place: event_place)

    other_user = create(:user, email: 'outro_user@email.com', password: 'password123')
    login_as other_user

    patch event_place_recommendation_path(event_place, recommendation), params: {
      event_place_recommendation: {
        name: 'Area 2',
        full_address: 'Rua Nova 456',
        phone: '51988888888'
      }
    }

    expect(response).to redirect_to(event_places_path)
    expect(response.status).to eq 302
  end
end
