require 'rails_helper'

describe 'Usuário tenta visualizar feedbacks' do
  context 'e falha' do
    it 'por não estar autenticado' do
      event = create(:event)
      visit event_feedbacks_path(event)
      expect(current_path).to eq new_user_session_path
    end

    it 'pelo evento ainda não ter terminado' do
      event_manager = create(:user, email: 'teste@email.com')
      create(:event, name: 'ccxp', status: :published, user: event_manager, start_date: 1.day.from_now, end_date: 2.days.from_now)

      login_as event_manager
      visit root_path
      within "nav#navbar" do
        click_on 'Meus Eventos'
      end
      click_on 'Gerenciar'

      expect(page).not_to have_link('Feedbacks')
    end

    it 'por não ser dono do evento' do
      event_manager = create(:user, email: 'teste@email.com')
      event = create(:event, name: 'ccxp', status: :published, user: event_manager,  start_date: 1.day.from_now, end_date: 2.days.from_now)

      feedbacks = {
        feedbacks: [
          {
            id: 1,
            title: 'Feedback 1',
            comment: 'comentário',
            mark: 3,
            user: 'Jaison'
          },
          {
            id: 2,
            title: 'Feedback 2',
            comment: 'comentário',
            mark: 1,
            user: 'Caio'
          }
        ]
      }
      other_event_manager = create(:user, email: 'manoel@email.com')
      Category.create!(name: 'Culinária')
      allow(ParticipantsApiService).to receive(:get_feedbacks_by_event_code).and_return(feedbacks)

      login_as other_event_manager
      visit event_feedbacks_path(event)

      expect(page).not_to have_content 'Feedback 1'
      expect(page).not_to have_content 'Caio'
    end
  end

  it 'com sucesso', js: true  do
    event_manager = create(:user, email: 'teste@email.com')
    create(:event, name: 'ccxp', status: :published, user: event_manager,  start_date: 1.day.from_now, end_date: 2.days.from_now)

    feedbacks = {
      feedbacks: [
        {
          id: 1,
          title: 'Feedback 1',
          comment: 'comentário',
          mark: 3,
          user: 'Jaison'
        },
        {
          id: 2,
          title: 'Feedback 2',
          comment: 'comentário',
          mark: 1,
          user: 'Caio'
        }
      ]
    }
    allow(ParticipantsApiService).to receive(:get_feedbacks_by_event_code).and_return(feedbacks)

      login_as event_manager
      Timecop.travel(3.days.from_now) do
        visit root_path
        within "nav#navbar" do
          click_on 'Meus Eventos'
        end
        click_on 'Gerenciar'
        click_on 'Feedbacks'

      expect(page).to have_content 'Feedback'
      expect(page).to have_content 'Caio'
    end
  end

  it 'e consegue filtrar por nota da avaliação' do
    event_manager = create(:user, email: 'teste@email.com')
    create(:event, name: 'ccxp', status: :published, user: event_manager,  start_date: 1.day.from_now, end_date: 2.days.from_now)

    feedbacks = {
      feedbacks: [
        {
          id: 1,
          title: 'Feedback 1',
          comment: 'comentário',
          mark: 3,
          user: 'Jaison'
        },
        {
          id: 2,
          title: 'Feedback 2',
          comment: 'comentário',
          mark: 1,
          user: 'Caio'
        }
      ]
    }
    allow(ParticipantsApiService).to receive(:get_feedbacks_by_event_code).and_return(feedbacks)

    login_as event_manager
    Timecop.travel(3.days.from_now) do
      visit root_path
      within "nav#navbar" do
          click_on 'Meus Eventos'
        end
      click_on 'Gerenciar'
      click_on 'Feedbacks'
      click_on '3'

      expect(page).to have_content 'Feedback 1'
      expect(page).to have_content 'Jaison'
      expect(page).not_to have_content 'Feedback 2'
    end
  end

  it 'e não ve feedback pois o evento não tem nenhum' do
    event_manager = create(:user, email: 'teste@email.com')
    create(:event, name: 'ccxp', status: :published, user: event_manager,  start_date: 1.day.from_now, end_date: 2.days.from_now)

    feedbacks = {
      feedbacks: []
    }
    allow(ParticipantsApiService).to receive(:get_feedbacks_by_event_code).and_return(feedbacks)

    login_as event_manager
    Timecop.travel(3.days.from_now) do
      visit root_path
      within "nav#navbar" do
          click_on 'Meus Eventos'
        end
      click_on 'Gerenciar'
      click_on 'Feedbacks'

      expect(page).to have_content 'Esse evento ainda não possui feedbacks'
    end
  end
end
