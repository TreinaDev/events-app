require 'rails_helper'

describe 'Usuário cria recomendações de lugares próximos ao local do evento' do
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
end
