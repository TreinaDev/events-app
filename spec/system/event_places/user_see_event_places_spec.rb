require 'rails_helper'

describe 'Usuário ve event places' do
  it 'e nao esta autenticado' do
    visit event_places_path

    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    user = create(:user)
    login_as user
    event_place = create(:event_place, user: user)

    visit event_places_path

    expect(page).to have_content event_place.name
    expect(page).to have_content event_place.street
    expect(page).to have_content event_place.number
    expect(page).to have_content event_place.neighborhood
    expect(page).to have_content event_place.city
    expect(page).to have_content event_place.state
    expect(page).to have_content event_place.zip_code
  end

  it 'outro usuario nao consegue ver' do
    user = create(:user)
    event_place = create(:event_place, user: user)

    other_user = create(:user, email: 'outro_user@email.com', password: 'password123')
    login_as other_user

    visit event_places_path

    expect(page).not_to have_content event_place.name
    expect(page).not_to have_content event_place.street
    expect(page).not_to have_content event_place.number
    expect(page).not_to have_content event_place.neighborhood
    expect(page).not_to have_content event_place.city
    expect(page).not_to have_content event_place.state
    expect(page).not_to have_content event_place.zip_code
  end
end
