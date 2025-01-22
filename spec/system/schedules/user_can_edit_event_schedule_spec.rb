require 'rails_helper'

describe 'Usuário edita horários do evento' do
  it 'e falha pois não está autenticado' do
    visit edit_event_schedule_path(1, 1)

    expect(current_path).to eq new_user_session_path
  end

  it 'e falha pois o evento é do outro usuário' do
    user = create(:user)
    second_user = create(:user, email: 'outro@email.com', registration_number: CPF.generate)
    event = create(:event, user: user)
    schedule = create(:schedule, event: event)

    login_as second_user
    visit edit_event_schedule_path(event, schedule)

    expect(current_path).to eq dashboard_path
  end

  it 'com sucesso' do
    user = create(:user)
    event = create(:event, user: user)
    create(:schedule, event: event)

    login_as user
    visit root_path
    click_on 'Eventos'
    click_on "#{event.name}"
    click_on 'Agenda'
    click_on 'Editar data'
    fill_in 'Data de início', with: (Time.now + 3.day).change(hour: 8, min: 0, sec: 0)
    fill_in 'Data de fim', with: (Time.now + 4.day).change(hour: 8, min: 0, sec: 0)
    click_on 'Salvar'

    expect(current_path).to eq event_path(event)
    expect(page).to have_content 'Datas editadas com sucesso.'
  end
end
