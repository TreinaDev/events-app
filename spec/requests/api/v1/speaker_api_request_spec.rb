require 'rails_helper'

describe 'Speaker API' do
    context 'POST /api/v1/speakers' do
      it 'sucesso' do
        user = create(:user)
        event = create(:event, user: user)
        schedule = create(:schedule, event: event)
        schedule_item = create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com")

        post api_v1_speakers_path, params: {
          email: schedule_item.responsible_email
        }

        json_response = JSON.parse(response.body)

        expect(response.status).to eq 200
        expect(json_response['token']).to be_present
        expect(response.content_type).to include('application/json')
      end

      it 'não encontrado' do
        user = create(:user)
        event = create(:event, user: user)
        schedule = create(:schedule, event: event)
        create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com")

        post api_v1_speakers_path, params: {
          email: 'joao@email.com'
        }

        json_response = JSON.parse(response.body)

        expect(response.status).to eq 404
        expect(json_response['error']).to be_present
        expect(response.content_type).to include('application/json')
      end
    end
end
