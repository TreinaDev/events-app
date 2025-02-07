require 'rails_helper'

describe 'Usuário consegue ver as breadcrumbs' do
  it 'na página de listagem de anuncios' do
    user = create(:user)
    event = create(:event, status: "published", user: user)
    login_as user

    visit event_announcements_path(event)

    expect(current_path).to eq event_announcements_path(event)
    within "#breadcrumbs" do
      expect(page).to have_link "Home"
      expect(page).to have_link "Meus Eventos"
      expect(page).to have_link "#{event.name}"
      expect(page).to have_content "Comunicados"
    end
  end
end
