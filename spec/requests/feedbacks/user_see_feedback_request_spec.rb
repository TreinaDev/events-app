require 'rails_helper'

describe 'Usuário tenta acessar o feedback' do
  it 'e falha pelo evento não ter sido finalizado' do
    event_manager = create(:user, email: 'teste@email.com')
    event = create(:event, name: 'ccxp', status: :published, user: event_manager, start_date: 1.day.from_now, end_date: 2.days.from_now)

    login_as event_manager
    get event_feedbacks_path(event)

    expect(response).to redirect_to root_path
    expect(response).to have_http_status :found
  end

  it 'e falha pelo evento ser um rascunho' do
    event_manager = create(:user, email: 'teste@email.com')
    event = create(:event, name: 'ccxp', status: :draft, user: event_manager, start_date: 1.day.from_now, end_date: 2.days.from_now)

    Timecop.travel(3.days.from_now) do
      login_as event_manager
      get event_feedbacks_path(event)

      expect(response).to redirect_to root_path
      expect(response).to have_http_status :found
    end
  end
end
