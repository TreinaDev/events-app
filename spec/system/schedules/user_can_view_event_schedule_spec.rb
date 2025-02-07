require 'rails_helper'

describe 'Usuário vê detalhes da agenda do evento' do
  it 'e falha pois não está autenticado' do
    visit event_schedule_path(1, 1)

    expect(current_path).to eq new_user_session_path
  end

  it 'e falha por tentar ver o a agenda de um evento do qual não é dono' do
    event_owner = create(:user)
    event = create(:event, user: event_owner)
    user_that_doesnt_own_the_event = create(:user, email: 'not_the@owner.com')
    login_as user_that_doesnt_own_the_event

    visit event_schedule_path(event, event.schedules[0])

    expect(current_path).to eq dashboard_path
    expect(page).to have_content "Acesso não autorizado."
  end

  it 'com sucesso' do
    user = create(:user)
    event = create(:event, user: user)
    schedule_item = create(:schedule_item, schedule: event.schedules[0])
    login_as user

    visit root_path
    within "nav#navbar" do
      click_on 'Meus Eventos'
    end
    click_on 'Gerenciar'
    click_on "Dia #{I18n.l(event.schedules.first.date.to_date, format: :short)}"

    expect(current_path).to eq event_schedule_path(event, event.schedules[0])
    expect(page).to have_content schedule_item.name
    expect(page).to have_content schedule_item.start_time.strftime('%H:%M')
    expect(page).to have_content schedule_item.end_time.strftime('%H:%M')
  end

  it 'e ve itens da agenda em ordem horário de início' do
    user = create(:user)
    event = create(:event, user: user)
    create(:schedule_item, schedule: event.schedules.first, name: 'Abertura', start_time: (Time.now).change(hour: 12, min: 15, sec: 0), end_time: (Time.now).change(hour: 13, min: 15, sec: 0))
    create(:schedule_item, schedule: event.schedules.first, schedule_type: :interval, name: 'Almoço', start_time: (Time.now).change(hour: 13, min: 15, sec: 0), end_time: (Time.now).change(hour: 14, min: 0, sec: 0))
    create(:schedule_item, schedule: event.schedules.first, name: 'Palestra rails', start_time: (Time.now).change(hour: 14, min: 15, sec: 0), end_time: (Time.now).change(hour: 15, min: 15, sec: 0))
    login_as user

    visit root_path
    within "nav#navbar" do
      click_on 'Meus Eventos'
    end
    click_on 'Gerenciar'
    click_on "Dia #{I18n.l(event.schedules.first.date.to_date, format: :short)}"

    items = all('[data-item-name]')
    expect(items.map(&:text)).to eq [ 'Abertura', 'Almoço', 'Palestra rails' ]
  end

  it 'e ve mensagem de que a agenda não possui atividades quando agenda esta vazia' do
    user = create(:user)
    event = create(:event, user: user)
    login_as user

    visit root_path
    within "nav#navbar" do
      click_on 'Meus Eventos'
    end
    click_on 'Gerenciar'
    click_on "Dia #{I18n.l(event.schedules.first.date.to_date, format: :short)}"

    expect(current_path).to eq event_schedule_path(event, event.schedules[0])
    expect(page).to have_content "Ainda não atividades na Agenda deste dia de Evento."
  end
end
