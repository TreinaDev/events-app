require 'rails_helper'

describe 'Usuário define horários de um evento' do
  it 'e falha pois não está autenticado' do
    visit new_event_schedule_path(1)

    expect(current_path).to eq new_user_session_path
  end

  it 'e cria uma agenda com sucesso' do
    user = create(:user)
    event = create(:event, user: user)

    login_as user

    visit root_path
    click_on 'Eventos'
    click_on "Gerenciar"
    click_on 'Agenda'
    within('#schedule-form') do
      fill_in 'Data de início', with: (Time.now + 1.day).change(hour: 8, min: 0, sec: 0)
      fill_in 'Data de fim', with: (Time.now + 2.day).change(hour: 8, min: 0, sec: 0)
    end
    click_on 'Salvar'

    expect(current_path).to eq event_path(event)
    expect(page).to have_content 'Datas cadastradas com sucesso.'
  end

  it 'e falha quando não informa a data de inicio ou data de fim' do
    user = create(:user)
    event = create(:event, user: user)

    login_as user

    visit new_event_schedule_path(event)
    click_on 'Salvar'

    expect(page).to have_content 'Data de início não pode ficar em branco'
    expect(page).to have_content 'Data de fim não pode ficar em branco'
  end

  it 'e falha quando a data de inicio vem depois da data de fim' do
    user = create(:user)
    event = create(:event, user: user)

    login_as user

    visit new_event_schedule_path(event)
    within('#schedule-form') do
      fill_in 'Data de início', with: (Time.now + 2.day).change(hour: 8, min: 0, sec: 0)
      fill_in 'Data de fim', with: (Time.now + 1.day).change(hour: 8, min: 0, sec: 0)
    end
    click_on 'Salvar'

    expect(page).to have_content 'Data de início deve vir antes da data de fim'
  end

  it 'e falha quando já possui uma agenda cadastrada' do
    user = create(:user)
    event = create(:event, user: user)
    create(:schedule, event: event)

    login_as user

    visit new_event_schedule_path(event)

    expect(current_path).to eq event_path(event)
    expect(page).to have_content 'Este evento já possui uma agenda cadastrada.'
  end
end
