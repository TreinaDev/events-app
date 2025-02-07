require 'rails_helper'

describe 'Usuário consegue ver as breadcrumbs' do
  it 'na página de detalhes de uma agenda' do
    user = create(:user)
    event = create(:event, user: user)
    schedule = create(:schedule, event: event)
    login_as user

    visit event_schedule_path(schedule.event, schedule)

    expect(current_path).to eq event_schedule_path(schedule.event, schedule)
    within "#breadcrumbs" do
      expect(page).to have_link "Home"
      expect(page).to have_link "Meus Eventos"
      expect(page).to have_link "#{event.name}"
      expect(page).to have_content "Agenda de #{I18n.l(schedule.date.to_date, format: :short)}"
    end
  end
end
