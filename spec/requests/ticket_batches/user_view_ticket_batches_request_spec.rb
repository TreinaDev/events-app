require 'rails_helper'

describe 'Usuário tenta visualizar lote' do
  it 'e falha pois o evento é de outro usuário' do
    event = create(:event)
    create(:ticket_batch, event: event)

    new_user = create(:user, email: 'marcelino@email.com')

    login_as new_user
    get event_ticket_batches_path(event)

    expect(response).to redirect_to root_path
    expect(response).to have_http_status :found
  end
end
