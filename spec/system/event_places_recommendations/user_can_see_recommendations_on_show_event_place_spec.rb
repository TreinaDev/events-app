require 'rails_helper'

describe 'Usuario ve recomendações de lugares proximos ao local do evento' do
  it 'com sucesso' do
    user = create(:user)
    event_place = create(:event_place, user: user)

    create(:event_place_recommendation,
      name: 'Restaurante 5 Estrelas', full_address: 'Rua do povo 123', phone: '51999999999',
      event_place: event_place
    )
    create(:event_place_recommendation,
      name: 'Restaurante Avenida', full_address: 'Rua Beira Rio 123', phone: '51999999888',
      event_place: event_place
    )

    login_as user
    visit event_place_path(event_place)

    expect(page).to have_content 'Restaurante 5 Estrelas'
    expect(page).to have_content 'Restaurante Avenida'

    expect(page).to have_content 'Rua do povo 123'
    expect(page).to have_content 'Rua Beira Rio 123'

    expect(page).to have_content '51999999999'
    expect(page).to have_content '51999999888'
  end
end
