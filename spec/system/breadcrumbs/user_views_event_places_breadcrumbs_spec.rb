require 'rails_helper'

describe 'Usuário consegue ver as breadcrumbs' do
  it 'na página de listagem de locais' do
    user = create(:user)
    create(:event_place, user: user)
    login_as user

    visit event_places_path

    expect(current_path).to eq event_places_path
    within "#breadcrumbs" do
      expect(page).to have_link "Home"
      expect(page).to have_content "Locais de Eventos"
    end
  end

  it 'na página de detalhes de um local' do
    user = create(:user)
    event_place = create(:event_place, user: user)
    login_as user

    visit event_place_path(event_place)

    expect(current_path).to eq event_place_path(event_place)
    within "#breadcrumbs" do
      expect(page).to have_link "Home"
      expect(page).to have_link "Locais de Evento"
      expect(page).to have_content "#{event_place.name}"
    end
  end

  it 'na página de criar um local de evento' do
    user = create(:user)
    login_as user

    visit new_event_place_path

    expect(current_path).to eq new_event_place_path
    within "#breadcrumbs" do
      expect(page).to have_link "Home"
      expect(page).to have_link "Locais de Evento"
      expect(page).to have_content "Novo Local"
    end
  end

  it 'na página de editar um local de evento' do
    user = create(:user)
    event_place = create(:event_place, user: user)
    login_as user

    visit edit_event_place_path(event_place)

    expect(current_path).to eq edit_event_place_path(event_place)
    within "#breadcrumbs" do
      expect(page).to have_link "Home"
      expect(page).to have_link "Locais de Evento"
      expect(page).to have_link "#{event_place.name}"
      expect(page).to have_content "Editar Local - #{event_place.name}"
    end
  end
end
