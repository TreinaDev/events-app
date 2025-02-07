require 'rails_helper'

describe 'Usuário consegue ver as breadcrumbs' do
  it 'na página de listagem de lotes de ingressos' do
    user = create(:user)
    event = create(:event, user: user)
    ticket_batch = create(:ticket_batch, event: event)
    login_as user

    visit event_ticket_batches_path(ticket_batch.event)

    expect(current_path).to eq event_ticket_batches_path(ticket_batch.event)
    within "#breadcrumbs" do
      expect(page).to have_link "Home"
      expect(page).to have_content "Lotes de Ingresso - Evento #{event.name}"
    end
  end

  it 'na página de criar lotes de ingressos' do
    user = create(:user)
    event = create(:event, user: user)
    ticket_batch = create(:ticket_batch, event: event)
    login_as user

    visit new_event_ticket_batch_path(ticket_batch.event)

    expect(current_path).to eq new_event_ticket_batch_path(ticket_batch.event)
    within "#breadcrumbs" do
      expect(page).to have_link "Home"
      expect(page).to have_link "Evento #{event.name}"
      expect(page).to have_link "Lotes de Ingresso - Evento #{event.name}"
      expect(page).to have_content "Criar Lote"
    end
  end

  it 'na página de editar lotes de ingressos' do
    user = create(:user)
    event = create(:event, user: user)
    ticket_batch = create(:ticket_batch, event: event)
    login_as user

    visit edit_event_ticket_batch_path(ticket_batch.event, ticket_batch)

    expect(current_path).to eq edit_event_ticket_batch_path(ticket_batch.event, ticket_batch)
    within "#breadcrumbs" do
      expect(page).to have_link "Home"
      expect(page).to have_link "Evento #{event.name}"
      expect(page).to have_link "Lotes de Ingresso - Evento #{event.name}"
      expect(page).to have_content "Editar Lote"
    end
  end
end
