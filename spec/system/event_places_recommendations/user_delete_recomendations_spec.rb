require 'rails_helper'

describe 'usuário deleta recomendações' do
  it 'com sucesso' do
    user = create(:user)
    event_place = create(:event_place, user: user)
    event_place_recommendation = create(:event_place_recommendation, event_place: event_place)
    login_as user

    visit event_place_path(event_place)

    click_on "delete_event_place_recommendation_#{event_place_recommendation.id}"

    expect(current_path).to eq event_place_path(event_place)

    expect(page).to have_content 'Recomendação de Local excluida com sucesso.'

    expect(page).not_to have_content event_place_recommendation.name
  end
end
