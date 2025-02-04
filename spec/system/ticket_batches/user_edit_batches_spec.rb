require 'rails_helper'

describe 'Usuário tenta editar lotes' do
  it 'e falha por não estar autenticado' do
    user = create(:user)
    event = create(:event, name: 'AAXP', user: user)
    ticket_batch = create(:ticket_batch, event: event)
    visit edit_event_ticket_batch_path(event, ticket_batch)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'com sucesso' do
    user = create(:user)
    event = create(:event, name: 'AAXP', user: user)
    batch = create(:ticket_batch, event: event)

    login_as user
    visit root_path
    click_on 'Gerenciar'
    click_on 'Lotes'
    find("a[data-test-id='edit-#{batch.id}']").click
    fill_in 'Nome', with: 'CCXP'
    click_on 'Atualizar'

    expect(page).to have_content 'Lote de Ingresso atualizado com sucesso'
    expect(page).to have_content 'CCXP'
  end

  it 'e falha ao tentar salvar com campo obrigatório em branco' do
    user = create(:user)
    event = create(:event, name: 'AAXP', user: user)
    batch = create(:ticket_batch, event: event)

    login_as user
    visit root_path
    click_on 'Gerenciar'
    click_on 'Lotes'
    find("a[data-test-id='edit-#{batch.id}']").click
    fill_in 'Nome', with: ''
    click_on 'Atualizar'

    expect(page).to have_content 'Lote de Ingresso não foi atualizado'
    expect(page).to have_content 'Nome não pode ficar em branco'
  end
end
