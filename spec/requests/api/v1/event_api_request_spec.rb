require 'rails_helper'

describe 'Event API' do
  context 'User sees events list' do
    it 'success' do
      user = create(:user)

      category = Category.create!(name: 'Palestra')

      event = build(
        :event, name: 'Formação de Churrasqueiros', user: user, status: 'published',
        address: 'Rua das Laranjeiras, 123', description: 'Aprenda a fazer churrasco como um profissional', participants_limit: 30,
        start_date:  (Time.now + 1.day).change(hour: 8, min: 0, sec: 0), end_date: (Time.now + 3.day).change(hour: 18, min: 0, sec: 0))


      event.logo.attach(io: File.open('spec/support/images/logo.png'), filename: 'logo.png', content_type: 'img/png')
      event.banner.attach(io: File.open('spec/support/images/banner.jpg'), filename: 'banner.png', content_type: 'img/jpg')

      event.save

      draft_event = create(
          :event, name: 'Formação de Padeiros', user: user, status: 'draft',
          address: 'Rua dos ipês, 343', description: 'Aprenda a fazer Pão como um profissional', categories: [ category ])

      get '/api/v1/events'

      expect(response).to have_http_status :success
      expect(response.content_type).to include('application/json')
      expect(response.parsed_body['events'][0]['name']).to include(event.name)
      expect(response.parsed_body['events'][0]['address']).to include(event.address)
      expect(response.parsed_body['events'][0]['description']).to include(event.description.body.to_html)
      expect(response.parsed_body['events'][0]['code']).to eq event.code
      expect(response.parsed_body['events'][0]['logo_url']).to eq url_for(event.logo)
      expect(response.parsed_body['events'][0]['banner_url']).to eq url_for(event.banner)
      expect(response.parsed_body['events'][0]['participants_limit']).to eq event.participants_limit
      expect(response.parsed_body['events'][0]['event_owner']).to eq event.user.name
      expect(response.parsed_body['events'][0]['start_date']).to eq event.start_date.iso8601(3)
      expect(response.parsed_body['events'][0]['end_date']).to eq event.end_date.iso8601(3)
      expect(response.parsed_body['events']).not_to include(draft_event.name)
      expect(response.parsed_body['events']).not_to include(draft_event.address)
      expect(response.parsed_body['events']).not_to include(draft_event.description)
      expect(response.parsed_body['events']).not_to include(draft_event.id)
    end
  end

  context 'User sees Event details' do
    it 'success' do
      user = create(:user)
      event = build(
        :event, name: 'Formação de Churrasqueiros', user: user, status: 'published',
        address: 'Rua das Laranjeiras, 123', description: 'Aprenda a fazer churrasco como um profissional', participants_limit: 30,
        start_date:  (Time.now + 1.day).change(hour: 8, min: 0, sec: 0), end_date: (Time.now + 1.day).change(hour: 18, min: 0, sec: 0))

      event.logo.attach(io: File.open('spec/support/images/logo.png'), filename: 'logo.png', content_type: 'img/png')
      event.banner.attach(io: File.open('spec/support/images/banner.jpg'), filename: 'banner.png', content_type: 'img/jpg')

      event.save

      schedule = event.schedules.first

      ticket_batch = create(:ticket_batch, event: event)

      coffee_break = create(:schedule_item, schedule: schedule, name: 'Coffee Break', start_time: (Time.now + 1.day).change(hour: 9, min: 0, sec: 0), end_time: (Time.now + 1.day).change(hour: 10, min: 0, sec: 0))
      music_lesson = create(:schedule_item, schedule: schedule, name: 'Aula de música', start_time: (Time.now + 1.day).change(hour: 10, min: 0, sec: 0), end_time: (Time.now + 1.day).change(hour: 11, min: 0, sec: 0))

      get "/api/v1/events/#{event.code}"

      expect(response).to have_http_status :success
      expect(response.content_type).to include('application/json')
      expect(response.parsed_body['name']).to include(event.name)
      expect(response.parsed_body['address']).to include(event.address)
      expect(response.parsed_body['description']).to include(event.description.body.to_html)
      expect(response.parsed_body['code']).to eq event.code
      expect(response.parsed_body['logo_url']).to eq url_for(event.logo)
      expect(response.parsed_body['banner_url']).to eq url_for(event.banner)
      expect(response.parsed_body['participants_limit']).to eq event.participants_limit
      expect(response.parsed_body['event_owner']).to eq event.user.name
      expect(response.parsed_body['start_date']).to eq event.start_date.iso8601(3)
      expect(response.parsed_body['end_date']).to eq event.end_date.iso8601(3)
      expect(response.parsed_body['ticket_batches'][0]['name']).to eq ticket_batch.name
      expect(response.parsed_body['ticket_batches'][0]['ticket_price'].to_f).to eq (ticket_batch.ticket_price)
      expect(response.parsed_body['ticket_batches'][0]['code']).to eq ticket_batch.code
      expect(response.parsed_body['schedules'][0]['date']).to eq schedule.date.strftime('%Y-%m-%d')
      expect(response.parsed_body['schedules'][0]['schedule_items'][0]['name']).to eq coffee_break.name
      expect(response.parsed_body['schedules'][0]['schedule_items'][1]['name']).to eq music_lesson.name
    end

    it "and event doesn't exist" do
      get "/api/v1/events/WRONG_CODE"

      expect(response).to have_http_status :not_found
      expect(response.content_type).to include('application/json')
    end
  end
end
