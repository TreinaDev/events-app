require 'rails_helper'

describe 'Usuário cria lotes' do
  it 'e falha por não estar autenticado' do
    user = create(:user)
    event = create(:event, name: 'AAXP', user: user)
    visit new_event_ticket_batch_path(event)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'com sucesso' do
    user = create(:user)
    event = create(:event, user: user)
    response_json = {
      id: 1,
      sold_tickets: 0
    }
    allow(ParticipantsApiService).to receive(:get_sold_tickets_count_by_event_and_batch_code).and_return(response_json)
    login_as user

    visit root_path
    click_on 'Gerenciar'
    click_on 'Lotes'
    click_on '+ Lote'
    fill_in 'Nome', with: 'Primeiro Lote'
    fill_in 'Limite de Ingresso', with: 30
    fill_in 'Data de Inicio', with: 1.week.from_now.strftime('%Y-%m-%d')
    fill_in 'Data Final', with: 3.weeks.from_now.strftime('%Y-%m-%d')
    fill_in 'Valor do Ingresso', with: 1000
    select 'Sem Desconto', from: 'Opção de Desconto'
    click_on 'Criar Lote'

    ticket_batch = TicketBatch.last
    expect(page).to have_content 'Lote de Ingresso adicionado com sucesso.'
    expect(page).to have_content 'Primeiro Lote'
    expect(page).to have_content '0 - 30'
    expect(page).to have_content 'R$ 1.000,00'
    expect(page).to have_content 'Sem Desconto'
    expect(page).to have_content I18n.l ticket_batch.start_date.to_date, format: :short
    expect(page).to have_content I18n.l ticket_batch.end_date.to_date, format: :short
    expect(current_path).to eq event_ticket_batches_path(event)
  end

  it 'e adiciona desconto meia-estudante' do
    user = create(:user)
    create(:event, user: user)
    login_as user

    visit root_path
    click_on 'Gerenciar'
    click_on 'Lotes'
    click_on '+ Lote'
    fill_in 'Nome', with: 'Primeiro Lote - Meia Estudante'
    fill_in 'Limite de Ingresso', with: 30
    fill_in 'Data de Inicio', with: 1.week.from_now.strftime('%Y-%m-%d')
    fill_in 'Data Final', with: 3.weeks.from_now.strftime('%Y-%m-%d')
    fill_in 'Valor do Ingresso', with: 1000
    select 'Meia Estudante', from: 'Opção de Desconto'
    click_on 'Criar Lote'

    expect(page).to have_content 'Primeiro Lote - Meia Estudante'
    expect(page).to have_content 'Meia Estudante'
    expect(page).to have_content 'R$ 500,00'
  end

  it 'e falha por informar dados inválidos' do
    user = create(:user)
    create(:event, user: user, participants_limit: 20)
    login_as user

    visit root_path
    click_on 'Gerenciar'
    click_on 'Lotes'
    click_on '+ Lote'
    fill_in 'Nome', with: ''
    fill_in 'Limite de Ingresso', with: 25
    fill_in 'Data de Inicio', with: 5.days.from_now.strftime('%Y-%m-%d')
    fill_in 'Data Final', with: 3.months.from_now.strftime('%Y-%m-%d')
    fill_in 'Valor do Ingresso', with: 1000
    select 'Meia Estudante', from: 'Opção de Desconto'
    click_on 'Criar Lote'

    expect(page).to have_content 'Lote de Ingresso não foi adicionado.'
    expect(page).to have_content 'Limite de Ingressos não deve ultrapassar o limite do evento'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(TicketBatch.count).to eq 0
  end
end
