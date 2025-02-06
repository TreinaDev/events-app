require 'rails_helper'

describe 'Usuário tenta editar um item de agenda' do
  it 'e falha pois não está autenticado' do
    visit edit_event_schedule_item_path(1, 1, 1)

    expect(current_path).to eq new_user_session_path
  end

  it 'e falha por tentar editar um item de agenda de um evento do qual não é dono' do
    event_owner = create(:user)
    event = create(:event, user: event_owner)
    schedule = create(:schedule, event: event)
    schedule_item = create(:schedule_item, schedule: schedule)

    login_as create(:user, email: 'not_the@owner.com')

    visit edit_event_schedule_item_path(event, schedule, schedule_item)

    expect(current_path).to eq dashboard_path
    expect(page).to have_content "Acesso não autorizado."
  end

  it 'com sucesso' do
    user = create(:user)
    event = create(:event, user: user, start_date: Time.now + 4.weeks, end_date: Time.now + 5.weeks)
    schedule = create(:schedule, event: event)
    schedule_item = create(:schedule_item, schedule: schedule)
    login_as user

    visit event_schedule_path(event, schedule)

    click_on "edit_schedule_item_#{schedule_item.id}"

    fill_in 'Nome', with: 'Nova atividade'
    fill_in 'Descrição', with: 'Nova descrição'
    fill_in 'Horário de Início', with: '10:00'
    fill_in 'Horário de Término', with: '12:00'
    fill_in 'Nome do Responsável', with: 'Novo responsável'
    fill_in 'E-mail do Responsável', with: 'novoresponsavel@example.com'
    click_on 'Atualizar'

    expect(current_path).to eq event_schedule_path(event, schedule)
    expect(page).to have_content 'Item atualizado com sucesso.'

    expect(page).to have_content 'Nova atividade'
    expect(page).to have_content '10:00'
    expect(page).to have_content '12:00'
    expect(page).to have_content 'Novo responsável'
  end

  it 'e vê as mensagens de erro com campos em branco' do
    user = create(:user)
    event = create(:event, user: user)
    schedule = create(:schedule, event: event)
    schedule_item = create(:schedule_item, schedule: schedule)
    login_as user

    visit edit_event_schedule_item_path(event, schedule, schedule_item)

    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Horário de Início', with: ''
    fill_in 'Horário de Término', with: ''
    fill_in 'Nome do Responsável', with: ''
    fill_in 'E-mail do Responsável', with: ''
    click_on 'Atualizar'

    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Descrição não pode ficar em branco')
    expect(page).to have_content('Horário de Início não pode ficar em branco')
    expect(page).to have_content('Horário de Término não pode ficar em branco')
    expect(page).to have_content('Nome do Responsável não pode ficar em branco')
    expect(page).to have_content('E-mail do Responsável não pode ficar em branco')
  end
end
