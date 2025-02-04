require 'rails_helper'

describe 'Usuário deleta event places' do
  it 'usuário deleta event place' do
    user = create(:user)
    event_place = create(:event_place, user: user)
    login_as user

    visit event_place_path(event_place)

    click_on "delete_event_place_#{event_place.id}"

    expect(current_path).to eq event_places_path

    expect(page).to have_content 'Local de Evento excluido com sucesso.'

    expect(page).not_to have_content event_place.name
  end
end
