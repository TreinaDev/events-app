require 'rails_helper'

describe 'Announces Api' do
  context 'Usuário ve lista de comunicados' do
    it 'com sucesso' do
      event_manager = create(:user, email: 'teste@email.com')
      event = create(:event, name: 'ccxp', status: :published, user: event_manager)
      announcement = create(:announcement, title: 'Distribuição de cartas One Piece', user: event_manager, event: event, description: 'perto do palco principal', created_at: 1.day.from_now)

      get "/api/v1/events/#{event.code}/announcements"

      expect(response).to have_http_status :success
      expect(response.content_type).to include('application/json')
      expect(response.parsed_body['announcements'][0]['title']).to eq announcement.title
      expect(response.parsed_body['announcements'][0]['code']).to eq announcement.code
      expect(response.parsed_body['announcements'][0]['description']).to include(announcement.description.body.to_html)
      expect(Time.parse(response.parsed_body['announcements'][0]['created_at']).utc.strftime("%Y-%m-%d %H:%M:%S")).to eq announcement.created_at.utc.strftime("%Y-%m-%d %H:%M:%S")
    end
  end

  context 'Usuário ve um comunicado' do
    it 'com sucesso' do
      event_manager = create(:user, email: 'teste@email.com')
      event = create(:event, name: 'ccxp', status: :published, user: event_manager)
      announcement = create(:announcement, title: 'Distribuição de cartas One Piece', user: event_manager, event: event, description: 'perto do palco principal', created_at: 1.day.from_now)

      get "/api/v1/events/#{event.code}/announcements/#{announcement.code}"

      expect(response).to have_http_status :success
      expect(response.content_type).to include('application/json')
      expect(response.parsed_body['announcement']['title']).to eq announcement.title
      expect(response.parsed_body['announcement']['code']).to eq announcement.code
      expect(response.parsed_body['announcement']['description']).to include(announcement.description.body.to_html)
      expect(Time.parse(response.parsed_body['announcement']['created_at']).utc.strftime("%Y-%m-%d %H:%M:%S")).to eq announcement.created_at.utc.strftime("%Y-%m-%d %H:%M:%S")
    end

    it 'e falha caso o comunicado nao seja encontrado' do
      event_manager = create(:user, email: 'teste@email.com')
      event = create(:event, name: 'ccxp', status: :published, user: event_manager)
      create(:announcement, title: 'Distribuição de cartas One Piece', user: event_manager, event: event, description: 'perto do palco principal')

      get "/api/v1/events/#{event.code}/announcements/WRONG_ID"

      expect(response).to have_http_status :not_found
      expect(response.content_type).to include('application/json')
      expect(response.body).to include("Announcement not found")
    end
  end
end
