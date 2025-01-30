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
      expect(response.parsed_body['events'][0]['uuid']).to eq event.uuid
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
        start_date:  (Time.now + 1.day).change(hour: 8, min: 0, sec: 0), end_date: (Time.now + 3.day).change(hour: 18, min: 0, sec: 0))

      event.logo.attach(io: File.open('spec/support/images/logo.png'), filename: 'logo.png', content_type: 'img/png')
      event.banner.attach(io: File.open('spec/support/images/banner.jpg'), filename: 'banner.png', content_type: 'img/jpg')

      event.save

      get "/api/v1/events/#{event.uuid}"

      expect(response).to have_http_status :success
      expect(response.content_type).to include('application/json')
      expect(response.parsed_body['name']).to include(event.name)
      expect(response.parsed_body['address']).to include(event.address)
      expect(response.parsed_body['description']).to include(event.description.body.to_html)
      expect(response.parsed_body['uuid']).to eq event.uuid
      expect(response.parsed_body['logo_url']).to eq url_for(event.logo)
      expect(response.parsed_body['banner_url']).to eq url_for(event.banner)
      expect(response.parsed_body['participants_limit']).to eq event.participants_limit
      expect(response.parsed_body['event_owner']).to eq event.user.name
      expect(response.parsed_body['start_date']).to eq event.start_date.iso8601(3)
      expect(response.parsed_body['end_date']).to eq event.end_date.iso8601(3)
    end

    it "and event doesn't exist" do
      get "/api/v1/events/WRONG_UUID"

      expect(response).to have_http_status :not_found
      expect(response.content_type).to include('application/json')
    end
  end
end
