require 'rails_helper'

describe 'Usuário cria recomendação de lugar de evento' do
  it 'com sucesso' do
    user = create(:user)
    event_place = create(:event_place, user: user)
    login_as user

    post event_place_recommendations_path(event_place), params: {
      event_place_recommendation: {
        name: 'Area 1',
        full_address: 'Rua do povo 123',
        phone: '51999999999'
      }
    }

    expect(response).to redirect_to(event_place_path(event_place))
    follow_redirect!

    expect(response.body).to include('Recomendação de Local criada com sucesso.')
    expect(response.body).to include('Area 1')
    expect(response.body).to include('Rua do povo 123')
  end

  it 'e falha por nao estar autenticado' do
    user = create(:user)
    event_place = create(:event_place, user: user)

    post event_place_recommendations_path(event_place), params: {
      event_place_recommendation: {
        name: 'Area 1',
        full_address: 'Rua do povo 123',
        phone: '51999999999'
      }
    }

    expect(response).to redirect_to new_user_session_path
    expect(response.status).to eq 302
  end

  it 'e falha ao tentar criar recomendação de outro usuário' do
    user = create(:user)
    event_place = create(:event_place, user: user)

    other_user = create(:user, email: 'outro_user@email.com', password: 'password123')
    login_as other_user

    post event_place_recommendations_path(event_place), params: {
      event_place_recommendation: {
        name: 'Area 1',
        full_address: 'Rua do povo 123',
        phone: '51999999999'
      }
    }

    expect(response).to redirect_to(event_places_path)
    expect(response.status).to eq 302
  end
end
