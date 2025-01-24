require 'rails_helper'

describe 'Usuário cadastra lote de ingresso' do
  it 'e falha por não estar autenticado' do
    manager = create(:user)
    event = create(:event, user: manager)

    post event_ticket_batches_path(event)

    expect(response).to redirect_to new_user_session_path
    expect(response).to have_http_status :found
  end

  it 'e falha por não ter permissão' do
    admin = create(:user, :admin)
    manager = create(:user)
    event = create(:event, user: manager)
    login_as admin

    post event_ticket_batches_path(event,
      { params:
        { ticket_batch:
          { name: 'Primeiro Lote',
            tickets_limit: 30,
            start_date: 3.days.from_now.strftime('%Y-%m-%d'),
            end_date: 3.months.from_now.strftime('%Y-%m-%d'),
            ticket_price: 1000,
            discount_option: :student
            }
          }
        }
      )

    expect(response).to redirect_to dashboard_path
    expect(response).to have_http_status :found
  end

  it 'com sucesso' do
    manager = create(:user)
    event = create(:event, user: manager)
    login_as manager

    post event_ticket_batches_path(event,
      { params:
        { ticket_batch:
          { name: 'Primeiro Lote',
            tickets_limit: 30,
            start_date: 3.days.from_now.strftime('%Y-%m-%d'),
            end_date: 3.months.from_now.strftime('%Y-%m-%d'),
            ticket_price: 1000,
            discount_option: :student
            }
          }
        }
      )

    expect(response).to redirect_to event_ticket_batches_path(event)
    expect(response).to have_http_status :found
  end
end
