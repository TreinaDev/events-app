require 'rails_helper'

describe 'Usuário vê detalhes da agenda do evento' do
  it 'e falha pois não está autenticado' do
    visit event_schedule_path(1, 1)

    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    user = create(:user)
    event = create(:event, user: user)
    schedule = create(:schedule, event: event)

    login_as user

    visit root_path
    click_on 'Eventos'
    click_on 'Gerenciar'
    click_on 'Agenda'

    expect(page).to have_content "Data de início: #{schedule.start_date.strftime('%d/%m/%Y %H:%M')}"
    expect(page).to have_content "Data de fim: #{schedule.end_date.strftime('%d/%m/%Y %H:%M')}"
    expect(current_path).to eq event_schedule_path(event, schedule)
  end

  it 'e é redirecionado para criar uma nova agenda caso nenhuma esteja cadastrada' do
    user = create(:user)
    event = create(:event, user: user)

    login_as user

    visit root_path
    click_on 'Eventos'
    click_on 'Gerenciar'
    click_on 'Agenda'

    expect(current_path).to eq new_event_schedule_path(event)
  end

  it 'e é redirecionado caso tente acessar a agenda de um evento de outro usuário' do
    user = create(:user)
    event = create(:event, user: user)
    schedule = create(:schedule, event: event)
    second_user = create(:user, email: 'joao@email.com', registration_number: CPF.generate)

    login_as second_user

    visit event_schedule_path(event, schedule)

    expect(current_path).to eq dashboard_path
  end

  it 'usuário vê os itens da agenda' do
    user = create(:user)
    event = create(:event, user: user)
    schedule = create(:schedule, event: event)
    schedule_item = create(:schedule_item, schedule: schedule)

    login_as user

    visit event_schedule_path(event, schedule)

    click_on I18n.l(schedule.start_date.to_date, format: :long)

    expect(page).to have_content schedule_item.name
    expect(page).to have_content schedule_item.start_time.strftime('%H:%M')
    expect(page).to have_content schedule_item.end_time.strftime('%H:%M')
  end
end
