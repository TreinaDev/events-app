require 'rails_helper'

describe 'Usuário tenta editar lotes' do
  it 'e falha por não estar autenticado' do
    user = create(:user)
    event = create(:event, name: 'AAXP', user: user)
    create(:ticket_batch, event: event)
    visit event_ticket_batches_path(event)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'com sucesso' do
    user = create(:user)
    event = create(:event, name: 'CCXP', user: user)
    ticket_batch = create(:ticket_batch, event: event)
    response_json = {
      id: 1,
      sold_tickets: 10
    }
    allow(ParticipantsApiService).to receive(:get_sold_tickets_count_by_event_and_batch_code).and_return(response_json)

    login_as user
    visit root_path
    within "nav#navbar" do
      click_on 'Meus Eventos'
    end
    click_on 'Gerenciar'
    click_on 'Lotes'

    expect(page).to have_content 'Lotes de Ingresso - Evento: CCXP'
    expect(page).to have_content 'CCXP'
    expect(page).to have_content '10 - 15'
    expect(page).to have_content "#{(response_json[:sold_tickets] * ticket_batch.ticket_price).to_s.sub('.', ',')}"
  end

  it 'e não consegue visualizar o lote de outro usuário' do
    user = create(:user)
    event = create(:event, name: 'CCXP', user: user)
    create(:ticket_batch, name: 'Ingresso Premium',  event: event)

    other_user = create(:user, email: 'milton@email.com')
    category = Category.create(name: 'Culinária')
    other_event = create(:event, name: 'Curso de pizza', user: other_user, categories: [ category ])
    create(:ticket_batch, name: 'Day one', event: other_event)

    login_as user
    visit root_path
    within "nav#navbar" do
      click_on 'Meus Eventos'
    end
    click_on 'Gerenciar'
    click_on 'Lotes'

    expect(page).to have_content 'Lotes de Ingresso - Evento: CCXP'
    expect(page).to have_content 'Ingresso Premium'
    expect(page).not_to have_content 'Day one'
  end
end
