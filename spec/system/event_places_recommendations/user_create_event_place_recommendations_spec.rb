require 'rails_helper'

describe 'Usuário cria recomendações de lugares próximos ao local do evento' do
  it 'e não esta autenticado' do
    user = create(:user)
    event_place = create(:event_place, user: user)

    visit new_event_place_recommendation_path(event_place)

    expect(current_path).to eq new_user_session_path
  end

  it 'outro usuario nao consegue ver' do
    user = create(:user)
    event_place = create(:event_place, user: user)

    other_user = create(:user, email: 'outro_user@email.com', password: 'password123')
    login_as other_user

    visit new_event_place_recommendation_path(event_place)

    expect(current_path).to eq event_places_path
  end

  it 'com sucesso' do
    user = create(:user)
    event_place = create(:event_place, user: user)
    login_as user

    visit event_places_path

    click_on event_place.name
    click_on 'Recomendar local'

    fill_in 'Nome', with: 'Hotel 5 Estrelas'
    fill_in 'Endereço Completo', with: 'Av. Padre Leopoldo Brentano, 180'
    fill_in 'Telefone', with: '51999999999'
    click_on 'Cadastrar'

    expect(page).to have_content('Recomendação de Local criada com sucesso.')
    expect(page).to have_content('Hotel 5 Estrelas')
    expect(page).to have_content('Av. Padre Leopoldo Brentano, 180')
    expect(page).to have_content('51999999999')
  end

  it 'e falha devido aos campos obrigatórios estar em branco' do
    user = create(:user)
    event_place = create(:event_place, user: user)
    login_as user

    visit event_places_path

    click_on event_place.name
    click_on 'Recomendar local'

    fill_in 'Nome', with: ''
    fill_in 'Endereço Completo', with: ''
    click_on 'Cadastrar'

    expect(page).to have_content('Falha ao criar a Recomendação de Local')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Endereço Completo não pode ficar em branco')
  end
end
