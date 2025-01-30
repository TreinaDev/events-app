require 'rails_helper'

describe 'Usuário adiciona um novo item de agenda' do
  it 'adiciona uma atividade com sucesso', js: true do
    user = create(:user)
    event = create(:event, user: user, start_date: 1.days.from_now, end_date: 3.days.from_now)

    login_as user

    visit root_path
    within 'nav' do
      click_on 'Eventos'
    end
    click_on 'Gerenciar'
    click_on 2.days.from_now.strftime('%d/%m')
    click_on 'Adicionar atividade'

    fill_in 'Nome', with: 'Atividade 1'
    fill_in 'Descrição', with: 'Atividade 1'
    fill_in 'Horário de Início', with: (Time.now + 2.day).change(hour: 10, min: 0).strftime('%Y-%m-%dT%H:%M')
    fill_in 'Horário de Término', with: (Time.now + 2.day).change(hour: 12, min: 0).strftime('%Y-%m-%dT%H:%M')
    fill_in 'Nome do Responsável', with: 'Fulano'
    fill_in 'E-mail do Responsável', with: 'responsável@example.com'
    click_on 'Salvar'

    expect(page).to have_content('Item criado com sucesso.')
  end

  it 'adiciona um intervalo com sucesso' do
    user = create(:user)
    event = create(:event, user: user, start_date: 1.days.from_now, end_date: 3.days.from_now)

    login_as user

    visit root_path
    within 'nav' do
      click_on 'Eventos'
    end
    click_on 'Gerenciar'
    click_on 2.days.from_now.strftime('%d/%m')
    click_on 'Adicionar atividade'

    choose 'Intervalo'

    fill_in 'Nome', with: 'Intervalo 1'
    fill_in 'Horário de Início', with: (Time.now + 2.day).change(hour: 12, min: 0).strftime('%Y-%m-%dT%H:%M')
    fill_in 'Horário de Término', with: (Time.now + 2.day).change(hour: 13, min: 0).strftime('%Y-%m-%dT%H:%M')
    click_on 'Salvar'

    expect(page).to have_content('Item criado com sucesso.')
  end

  it 'e vê as mensagens de erro com campos em branco' do
    user = create(:user)
    event = create(:event, user: user)

    login_as user

    visit new_event_schedule_item_path(event, event.schedules.first)

    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Horário de Início', with: ''
    fill_in 'Horário de Término', with: ''
    fill_in 'Nome do Responsável', with: ''
    fill_in 'E-mail do Responsável', with: ''
    click_on 'Salvar'

    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Descrição não pode ficar em branco')
    expect(page).to have_content('Horário de Início não pode ficar em branco')
    expect(page).to have_content('Horário de Término não pode ficar em branco')
    expect(page).to have_content('Nome do Responsável não pode ficar em branco')
    expect(page).to have_content('E-mail do Responsável não pode ficar em branco')
  end

  it 'e vê as mensagens de erro com horário de término menor que o horário de início' do
    user = create(:user)
    event = create(:event, user: user)

    login_as user

    visit new_event_schedule_item_path(event, event.schedules.first)

    fill_in 'Horário de Início', with: (Time.now + 2.day).change(hour: 10, min: 0).strftime('%Y-%m-%dT%H:%M')
    fill_in 'Horário de Término', with: (Time.now + 2.day).change(hour: 8, min: 0).strftime('%Y-%m-%dT%H:%M')
    click_on 'Salvar'

    expect(page).to have_content('Horário de Término deve ser depois do início')
  end

  it 'e não vê os campos descrição, nome do responsável e e-mail do responsável ao adicionar um intervalo', js: true do
    user = create(:user)
    event = create(:event, user: user)

    login_as user

    visit new_event_schedule_item_path(event, event.schedules.first)

    choose 'Intervalo'

    expect(page).not_to have_field('Descrição')
    expect(page).not_to have_field('Nome do Responsável')
    expect(page).not_to have_field('E-mail do Responsável')
  end
end
