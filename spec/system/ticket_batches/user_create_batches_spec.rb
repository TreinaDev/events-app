require 'rails_helper'

describe 'Usuário cria lotes' do
  it 'com sucesso' do
    user = create(:user)
    event = create(:event, user: user)
    login_as user

    visit events_path
    click_on 'Lollapalooza'
    click_on 'Lotes'
    click_on '+ Lote'
    fill_in 'Nome', with: 'Primeiro Lote'
    fill_in 'Limite de Ingresso', with: 30
    fill_in 'Data de Inicio', with: 3.days.from_now.strftime('%Y-%m-%d')
    fill_in 'Data Final', with: 3.months.from_now.strftime('%Y-%m-%d')
    fill_in 'Valor do Ingresso', with: 1000
    select 'Meia Estudante', from: 'Opção de Desconto'
    click_on 'Criar Lote'

    expect(page).to have_content 'Primeiro Lote'
    expect(page).to have_content 'Lote de Ingresso adicionado com sucesso.'
    expect(current_path).to eq event_ticket_batches_path(event)
  end
end
