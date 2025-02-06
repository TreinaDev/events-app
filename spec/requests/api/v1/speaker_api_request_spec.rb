require 'rails_helper'

describe 'Speaker API' do
  context 'Gera code a partir do email' do
    it 'com sucesso' do
      user = create(:user)
      event = create(:event, user: user)
      schedule = create(:schedule, event: event)
      schedule_item = create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com")

      post "/api/v1/speakers", params: {
        email: schedule_item.responsible_email
      }

      json_response = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(json_response['code']).to be_present
      expect(response.content_type).to include('application/json')
    end

    it 'e e-mail não é encontrado' do
      user = create(:user)
      event = create(:event, user: user)
      schedule = create(:schedule, event: event)
      create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com")

      post "/api/v1/speakers", params: {
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

      post "/api/v1/speakers", params: {
        email: schedule_item.responsible_email
      }

      expect(response.status).to eq 500
    end

    it 'falha caso e-mail não seja fornecido na requisição' do
      user = create(:user)
      event = create(:event, user: user)
      schedule = create(:schedule, event: event)
      create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com")

      post "/api/v1/speakers"

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

      get "/api/v1/speakers/#{speaker.code}/events"

      json_response = JSON.parse(response.body)
      expect(json_response[0]['name']).to eq 'Conferência Ruby'
      expect(json_response[0]['logo_url']).to eq rails_blob_url(event.logo, only_path: false)
      expect(json_response[0]['banner_url']).to eq rails_blob_url(event.banner, only_path: false)
      expect(json_response.size).to eq 1
      expect(response.status).to eq 200
      expect(response.content_type).to include('application/json')
    end

    it 'e code não é encontrado' do
      user = create(:user)
      event = create(:event, user: user, name: "Conferência Ruby")
      schedule = create(:schedule, event: event)
      create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com")

      get "/api/v1/speakers/INVALID_CODE/events"

      json_response = JSON.parse(response.body)
      expect(json_response["error"]). to eq 'Código não pertence a nenhum palestrante.'
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

      get "/api/v1/speakers/#{speaker.code}/events"

      expect(response.status).to eq 500
    end
  end

  context 'Busca agendas de um evento que o palestrante esteja participando' do
    it 'com sucesso' do
      user = create(:user)
      event = create(:event, user: user, name: "Conferência Ruby")
      schedule = create(:schedule, event: event)
      schedule_item = create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com")
      create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com", start_time: (Time.now + 1.day).change(hour: 10, min: 0, sec: 0), end_time: (Time.now + 1.day).change(hour: 11, min: 0, sec: 0))
      speaker = Speaker.last

      get "/api/v1/speakers/#{speaker.code}/schedules/#{event.code}"

      json_response = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(json_response[0]['date']).to eq schedule.date.strftime("%Y-%m-%d")
      expect(json_response[0]['activities'][0]['name']).to eq schedule_item.name
      expect(response.content_type).to include('application/json')
    end

    it 'e código do participante não é encontrado' do
      user = create(:user)
      event = create(:event, user: user, name: "Conferência Ruby")
      schedule = create(:schedule, event: event)
      create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com")
      create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com", start_time: (Time.now + 1.day).change(hour: 10, min: 0, sec: 0), end_time: (Time.now + 1.day).change(hour: 11, min: 0, sec: 0))

      get "/api/v1/speakers/INVALID_CODE/schedules/#{event.code}"

      json_response = JSON.parse(response.body)
      expect(json_response["error"]). to eq 'Código não pertence a nenhum palestrante.'
      expect(response.status).to eq 404
      expect(response.content_type).to include('application/json')
    end

    it 'e código do evento não é encontrado' do
      user = create(:user)
      event = create(:event, user: user, name: "Conferência Ruby")
      schedule = create(:schedule, event: event)
      create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com")
      create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com", start_time: (Time.now + 1.day).change(hour: 10, min: 0, sec: 0), end_time: (Time.now + 1.day).change(hour: 11, min: 0, sec: 0))
      speaker = Speaker.last

      get "/api/v1/speakers/#{speaker.code}/schedules/INVALID_CODE"

      json_response = JSON.parse(response.body)
      expect(json_response["error"]). to eq 'Palestrante não possui nenhum evento com esse código.'
      expect(response.status).to eq 404
      expect(response.content_type).to include('application/json')
    end

    it 'e falha com um erro interno de servidor' do
      user = create(:user)
      event = create(:event, user: user)
      schedule = create(:schedule, event: event)
      create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com")
      speaker = Speaker.last
      allow(Speaker).to receive(:find_by).and_raise(ActiveRecord::ActiveRecordError)

      get "/api/v1/speakers/#{speaker.code}/schedules/#{event.code}"

      expect(response.status).to eq 500
    end
  end

  context 'Busca item de agenda do palestrante' do
    it 'com sucesso' do
      user = create(:user)
      event = create(:event, user: user)
      schedule = create(:schedule, event: event)
      schedule_item = create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com")
      speaker = Speaker.last

      get "/api/v1/speakers/#{speaker.code}/schedule_item/#{schedule_item.code}"

      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq 'Palestra'
      expect(response.status).to eq 200
      expect(response.content_type).to include('application/json')
      expect(json_response['event']['code']).to eq event.code
      expect(json_response['event']['start_date']).to eq event.start_date.iso8601(3)
      expect(json_response['event']['end_date']).to eq event.end_date.iso8601(3)
    end

    it 'e código do palestrante não é encontrado' do
      user = create(:user)
      event = create(:event, user: user)
      schedule = create(:schedule, event: event)
      schedule_item = create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com")

      get "/api/v1/speakers/INVALID_CODE/schedule_item/#{schedule_item.code}"

      json_response = JSON.parse(response.body)
      expect(json_response["error"]). to eq 'Código não pertence a nenhum palestrante.'
      expect(response.status).to eq 404
      expect(response.content_type).to include('application/json')
    end

    it 'e código do item da agenda não é encontrado' do
      user = create(:user)
      event = create(:event, user: user, name: "Conferência Ruby")
      schedule = create(:schedule, event: event)
      create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com")
      create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com", start_time: (Time.now + 1.day).change(hour: 10, min: 0, sec: 0), end_time: (Time.now + 1.day).change(hour: 11, min: 0, sec: 0))
      speaker = Speaker.last

      get "/api/v1/speakers/#{speaker.code}/schedule_item/INVALID_CODE"

      json_response = JSON.parse(response.body)
      expect(json_response["error"]). to eq 'Palestrante não possui nenhum item de agenda com esse código.'
      expect(response.status).to eq 404
      expect(response.content_type).to include('application/json')
    end

    it 'e falha com um erro interno de servidor' do
      user = create(:user)
      event = create(:event, user: user)
      schedule = create(:schedule, event: event)
      schedule_item = create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com")
      speaker = Speaker.last
      allow(Speaker).to receive(:find_by).and_raise(ActiveRecord::ActiveRecordError)

      get "/api/v1/speakers/#{speaker.code}/schedule_item/#{schedule_item.code}"

      expect(response.status).to eq 500
    end
  end

  context 'Busca detalhes de um evento do palestrante' do
    it 'com sucesso' do
      user = create(:user)
      event = create(:event, user: user, name: 'Tropical Rails Fake')
      schedule = create(:schedule, event: event)
      create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com")
      speaker = Speaker.last

      get "/api/v1/speakers/#{speaker.code}/event/#{event.code}"

      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq 'Tropical Rails Fake'
      expect(response.status).to eq 200
      expect(response.content_type).to include('application/json')
    end

    it 'e o código do palestrante não é encontrado' do
      user = create(:user)
      event = create(:event, user: user)
      schedule = create(:schedule, event: event)
      create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com")

      get "/api/v1/speakers/INVALID_CODE/event/#{event.code}"

      json_response = JSON.parse(response.body)
      expect(json_response["error"]). to eq 'Código não pertence a nenhum palestrante.'
      expect(response.status).to eq 404
      expect(response.content_type).to include('application/json')
    end

    it 'e código do evento não é encontrado' do
      user = create(:user)
      event = create(:event, user: user)
      schedule = create(:schedule, event: event)
      create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com")
      speaker = Speaker.last

      get "/api/v1/speakers/#{speaker.code}/event/INVALID_CODE"

      json_response = JSON.parse(response.body)
      expect(json_response["error"]). to eq 'Palestrante não possui nenhum evento com esse código.'
      expect(response.status).to eq 404
      expect(response.content_type).to include('application/json')
    end

    it 'e falha com um erro interno de servidor' do
      user = create(:user)
      event = create(:event, user: user)
      schedule = create(:schedule, event: event)
      create(:schedule_item, schedule: schedule, responsible_email: "marcos@email.com")
      speaker = Speaker.last
      allow(Speaker).to receive(:find_by).and_raise(ActiveRecord::ActiveRecordError)

      get "/api/v1/speakers/#{speaker.code}/event/#{event.code}"

      expect(response.status).to eq 500
    end
  end
end
