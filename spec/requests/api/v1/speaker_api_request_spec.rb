require 'rails_helper'

describe 'Speaker API' do
    context 'Gera token a partir do email' do
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

      it 'falha com um erro interno de servidor' do
        allow(Speaker).to receive(:find_by).and_raise(ActiveRecord::ActiveRecordError)
        user = create(:user)
        event = create(:event, user: user)
        schedule = create(:schedule, event: event)
        schedule_item = create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com")

        post api_v1_speakers_path, params: {
          email: schedule_item.responsible_email
        }

        expect(response.status).to eq 500
      end

      it 'falha caso e-mail não seja fornecido na requisição' do
        user = create(:user)
        event = create(:event, user: user)
        schedule = create(:schedule, event: event)
        create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com")

        post api_v1_speakers_path

        json_response = JSON.parse(response.body)
        expect(response.status).to eq 400
        expect(json_response["error"]).to eq 'E-mail não fornecido'
      end
    end
end
