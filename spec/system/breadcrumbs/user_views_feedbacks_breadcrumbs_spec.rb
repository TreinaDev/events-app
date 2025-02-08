require 'rails_helper'

describe 'Usuário consegue ver as breadcrumbs' do
  it 'na página de listagem de feedbacks' do
    user = create(:user)
    event = create(:event, status: "published", user: user, start_date: 1.day.from_now, end_date: 2.day.from_now)
    login_as user

    Timecop.travel(3.days.from_now) do
      visit event_feedbacks_path(event)

      expect(current_path).to eq event_feedbacks_path(event)
      within "#breadcrumbs" do
        expect(page).to have_link "Home"
        expect(page).to have_link "#{event.name}"
        expect(page).to have_content "Feedbacks"
      end
    end
  end
end
