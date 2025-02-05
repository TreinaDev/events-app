require 'rails_helper'

describe 'Usuário edita recomendação de local de evento' do
  it 'e nao esta autenticado' do
    user = create(:user)
    event_place = create(:event_place, user: user)
    event_place_recommendation = create(:event_place_recommendation, event_place: event_place)

    visit edit_event_place_recommendation_path(event_place, event_place_recommendation)

    expect(current_path).to eq new_user_session_path
  end

  it 'outro usuario nao consegue editar e é redirecionado' do
    user = create(:user)
    event_place = create(:event_place, user: user)

    event_place_recommendation = create(:event_place_recommendation, event_place: event_place)

    other_user = create(:user, email: 'outro_user@email.com', password: 'password123')
    login_as other_user

    visit edit_event_place_recommendation_path(event_place, event_place_recommendation)

    expect(current_path).to eq event_places_path
  end

  it 'com sucesso' do
    user = create(:user)
    event_place = create(:event_place, user: user)

    event_place_recommendation = create(:event_place_recommendation, event_place: event_place)

    login_as user

    visit event_place_path(event_place)

    click_on "edit_event_place_recommendation_#{event_place_recommendation.id}"

    fill_in 'Nome', with: 'Novo nome'
    fill_in 'Endereço Completo', with: 'Novo endereço completo'
    fill_in 'Telefone', with: '51888888888'
    click_on 'Atualizar'

    expect(current_path).to eq event_place_path(event_place)

    expect(page).to have_content 'Recomendação de Local atualizada com sucesso.'
    expect(page).to have_content 'Novo nome'
    expect(page).to have_content 'Novo endereço completo'
    expect(page).to have_content '51888888888'
  end

  it 'e falha devido aos campos obrigatórios estar em branco' do
    user = create(:user)
    event_place = create(:event_place, user: user)

    event_place_recommendation = create(:event_place_recommendation, event_place: event_place)

    login_as user

    visit event_place_path(event_place)

    click_on "edit_event_place_recommendation_#{event_place_recommendation.id}"

    fill_in 'Nome', with: ''
    fill_in 'Endereço Completo', with: ''
    click_on 'Atualizar'

    expect(current_path).to eq event_place_recommendation_path(event_place, event_place_recommendation)

    expect(page).to have_content 'Falha ao atualizar a Recomendação de Local'

    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Endereço Completo não pode ficar em branco'
  end
end
