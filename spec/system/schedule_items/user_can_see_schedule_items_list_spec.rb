require 'rails_helper'

describe 'Usuário vê lista de eventos' do
  it 'e vê eventos' do
    user = create(:user)
    event = create(:event, user: user, start_date: 1.days.from_now, end_date: 5.days.from_now)
    create(:schedule_item, name: 'Palestra', schedule: event.schedules.first,
      start_time: '10:00', end_time: '11:00'
    )
    create(:schedule_item, name: 'Workshop', schedule: event.schedules.first,
      start_time: '11:00', end_time: '12:00'
    )
    create(:schedule_item, name: 'Coffee Break', schedule: event.schedules.first,
      schedule_type: :interval, start_time: '12:00', end_time: '13:00'
    )

    login_as user

    visit event_path(event)
    click_on 1.day.from_now.strftime('%d/%m')

    expect(page).to have_content('Palestra')
    expect(page).to have_content('10:00 - 11:00')
    expect(page).to have_content('Workshop')
    expect(page).to have_content('11:00 - 12:00')
    expect(page).to have_content('Coffee Break')
    expect(page).to have_content('12:00 - 13:00')
  end
end
