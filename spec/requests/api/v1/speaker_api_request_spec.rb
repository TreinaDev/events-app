require 'rails_helper'

describe 'Speaker API' do
    context 'Gera token a partir do email' do
      it 'com sucesso' do
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

      it 'e e-mail não é encontrado' do
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
        user = create(:user)
        event = create(:event, user: user)
        schedule = create(:schedule, event: event)
        schedule_item = create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com")
        allow(Speaker).to receive(:find_by).and_raise(ActiveRecord::ActiveRecordError)

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

  context 'Busca eventos do palestrante' do
    it 'com sucesso' do
      user = create(:user)
      event = create(:event, user: user, name: "Conferência Ruby")
      schedule = create(:schedule, event: event)
      create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com")
      create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com", start_time: (Time.now + 1.day).change(hour: 10, min: 0, sec: 0), end_time: (Time.now + 1.day).change(hour: 11, min: 0, sec: 0))
      speaker = Speaker.last

      get "/api/v1/speakers/#{speaker.token}/events"

      json_response = JSON.parse(response.body)
      expect(json_response[0]['name']).to eq 'Conferência Ruby'
      expect(json_response.size).to eq 1
      expect(response.status).to eq 200
      expect(response.content_type).to include('application/json')
    end

    it 'e token não é encontrado' do
      user = create(:user)
      event = create(:event, user: user, name: "Conferência Ruby")
      schedule = create(:schedule, event: event)
      create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com")

      get "/api/v1/speakers/INVALID_TOKEN/events"

      json_response = JSON.parse(response.body)
      expect(json_response["error"]). to eq 'Token não pertence a nenhuma palestrante.'
      expect(response.status).to eq 404
      expect(response.content_type).to include('application/json')
    end

    it 'falha com um erro interno de servidor' do
      user = create(:user)
      event = create(:event, user: user)
      schedule = create(:schedule, event: event)
      create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com")
      speaker = Speaker.last
      allow(Speaker).to receive(:find_by).and_raise(ActiveRecord::ActiveRecordError)

      get "/api/v1/speakers/#{speaker.token}/events"

      expect(response.status).to eq 500
    end
  end
end
