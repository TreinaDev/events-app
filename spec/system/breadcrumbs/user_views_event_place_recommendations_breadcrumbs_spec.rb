require 'rails_helper'

describe 'Usuário consegue ver as breadcrumbs' do
  it 'na página de criar uma recomendaçao de local de evento' do
    user = create(:user)
    event_place = create(:event_place, user: user)
    create(:event_place_recommendation, event_place: event_place)
    login_as user

    visit new_event_place_recommendation_path(event_place)

    expect(current_path).to eq new_event_place_recommendation_path(event_place)
    within "#breadcrumbs" do
      expect(page).to have_link "Home"
      expect(page).to have_link "Locais de Evento"
      expect(page).to have_link "#{event_place.name}"
      expect(page).to have_content "Adicionar Recomendação"
    end
  end

  it 'na página de editar uma recomendaçao de local de evento' do
    user = create(:user)
    event_place = create(:event_place, user: user)
    event_place_recommendation = create(:event_place_recommendation, event_place: event_place)
    login_as user

    visit edit_event_place_recommendation_path(event_place, event_place_recommendation)

    expect(current_path).to eq edit_event_place_recommendation_path(event_place, event_place_recommendation)
    within "#breadcrumbs" do
      expect(page).to have_link "Home"
      expect(page).to have_link "Locais de Evento"
      expect(page).to have_link "#{event_place.name}"
      expect(page).to have_content "Editar Recomendação - #{event_place_recommendation.name}"
    end
  end
end
