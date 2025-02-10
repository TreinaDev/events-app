require 'rails_helper'

describe 'Event API' do
  context 'Usuário vê lista de eventos' do
    it 'com sucesso' do
      user = create(:user)
      category = Category.create!(name: 'Palestra')
      event = build(:event, user: user, status: 'published',
        name: 'Formação de Churrasqueiros',
        description: 'Aprenda a fazer churrasco como um profissional',
        event_type: :inperson,
        event_place: create(:event_place, user: user, street: 'Rua das Laranjeiras', number: '123'),
        participants_limit: 30,
        start_date:  (Time.now + 1.day).change(hour: 8, min: 0, sec: 0),
        end_date: (Time.now + 3.day).change(hour: 18, min: 0, sec: 0)
        )
        event.logo.attach(io: File.open('spec/support/images/logo.jpg'), filename: 'logo.jpg', content_type: 'img/png')
      event.banner.attach(io: File.open('spec/support/images/banner.png'), filename: 'banner.png', content_type: 'img/jpg')
      event.save
      draft_event = create(:event, user: user, status: 'draft',
        name: 'Formação de Padeiros',
        event_place: create(:event_place, name: 'Ouro Branco', street: 'Rua dos ipês', number: '343', user: user),
        description: 'Aprenda a fazer Pão como um profissional',
        categories: [ category ]
        )

      get '/api/v1/events'

      expect(response).to have_http_status :success
      expect(response.content_type).to include('application/json')
      expect(response.parsed_body['events'][0]['code']).to eq event.code
      expect(response.parsed_body['events'][0]['name']).to include('Formação de Churrasqueiros')
      expect(response.parsed_body['events'][0]['description']).to include('Aprenda a fazer churrasco como um profissional')
      expect(response.parsed_body['events'][0]['event_type']).to include('inperson')
      expect(response.parsed_body['events'][0]['address']).to include('Rua das Laranjeiras, 123')
      expect(response.parsed_body['events'][0]['logo_url']).to eq url_for(event.logo)
      expect(response.parsed_body['events'][0]['banner_url']).to eq url_for(event.banner)
      expect(response.parsed_body['events'][0]['participants_limit']).to eq event.participants_limit
      expect(response.parsed_body['events'][0]['event_owner']).to eq event.user.name
      expect(response.parsed_body['events'][0]['start_date']).to eq event.start_date.iso8601(3)
      expect(response.parsed_body['events'][0]['end_date']).to eq event.end_date.iso8601(3)
      expect(response.parsed_body['events']).not_to include('Formação de Padeiros')
      expect(response.parsed_body['events']).not_to include('Rua dos ipês, 343')
      expect(response.parsed_body['events']).not_to include('Aprenda a fazer Pão como um profissional')
      expect(response.parsed_body['events']).not_to include(draft_event.id)
    end

    it 'e se o evento for online, não vê o endereço' do
      user = create(:user)
      event = build(:event, user: user, status: 'published',
        name: 'Formação de Churrasqueiros',
        description: 'Aprenda a fazer churrasco como um profissional',
        event_type: :online,
        participants_limit: 30,
        start_date:  (Time.now + 1.day).change(hour: 8, min: 0, sec: 0),
        end_date: (Time.now + 3.day).change(hour: 18, min: 0, sec: 0)
        )
        event.logo.attach(io: File.open('spec/support/images/logo.jpg'), filename: 'logo.jpg', content_type: 'img/png')
        event.banner.attach(io: File.open('spec/support/images/banner.png'), filename: 'banner.png', content_type: 'img/jpg')
      event.save

      get '/api/v1/events'

      expect(response).to have_http_status :success
      expect(response.content_type).to include('application/json')
      expect(response.parsed_body['events'][0]['code']).to eq event.code
      expect(response.parsed_body['events'][0]['name']).to include('Formação de Churrasqueiros')
      expect(response.parsed_body['events'][0]['description']).to include('Aprenda a fazer churrasco como um profissional')
      expect(response.parsed_body['events'][0]['event_type']).to include('online')
      expect(response.parsed_body['events'][0]).not_to have_key('address')
    end

    it 'e envia uma query' do
      user = create(:user)
      category = Category.create!(name: 'Palestra')
      event = build(:event, user: user, status: 'published',
        name: 'Formação de Churrasqueiros',
        description: 'Aprenda a fazer churrasco como um profissional',
        event_type: :inperson,
        event_place: create(:event_place, user: user, street: 'Rua das Laranjeiras', number: '123'),
        participants_limit: 30,
        start_date:  (Time.now + 1.day).change(hour: 8, min: 0, sec: 0),
        end_date: (Time.now + 3.day).change(hour: 18, min: 0, sec: 0)
        )
        event.logo.attach(io: File.open('spec/support/images/logo.jpg'), filename: 'logo.jpg', content_type: 'img/jpg')
        event.banner.attach(io: File.open('spec/support/images/banner.png'), filename: 'banner.png', content_type: 'img/png')
      event.save
      create(:event, user: user, status: 'published',
        name: 'Formação de Padeiros',
        description: 'Aprenda a fazer Pão como um profissional',
        event_place: create(:event_place, name: 'Ouro Branco', street: 'Rua dos ipês', number: '343', user: user),
        categories: [ category ]
        )

      get '/api/v1/events', params: { query: event.name }

      expect(response).to have_http_status :success
      expect(response.content_type).to include('application/json')
      expect(response.parsed_body['events'][0]['name']).to include(event.name)
      expect(response.parsed_body['events'][0]['address']).to include('Rua das Laranjeiras, 123')
      expect(response.parsed_body['events'][0]['description']).to include(event.description.body.to_html)
      expect(response.parsed_body['events'][0]['code']).to eq event.code
      expect(response.parsed_body['events'][0]['logo_url']).to eq url_for(event.logo)
      expect(response.parsed_body['events'][0]['banner_url']).to eq url_for(event.banner)
      expect(response.parsed_body['events'][0]['participants_limit']).to eq event.participants_limit
      expect(response.parsed_body['events'][0]['event_owner']).to eq event.user.name
      expect(response.parsed_body['events'][0]['start_date']).to eq event.start_date.iso8601(3)
      expect(response.parsed_body['events'][0]['end_date']).to eq event.end_date.iso8601(3)
      expect(response.parsed_body['events'].count).to eq 1
    end

    it 'e envia uma keyword na query, e recebe os eventos relacionados' do
      user = create(:user)

      category = Category.create!(name: 'Palestra')
      keyword = Keyword.create!(value: 'programming')
      CategoryKeyword.create!(category: category, keyword: keyword)

      event = build(
        :event, name: 'Formação de Churrasqueiros', user: user, status: 'published', categories: [ category ]
      )
      event.logo.attach(io: File.open('spec/support/images/logo.jpg'), filename: 'logo.jpg', content_type: 'img/jpg')
      event.banner.attach(io: File.open('spec/support/images/banner.png'), filename: 'banner.jpg', content_type: 'img/png')
      event.save

      other_category = Category.create!(name: 'Workshop')
      other_keyword = Keyword.create!(value: 'ruby')
      CategoryKeyword.create!(category: other_category, keyword: other_keyword)

      other_event = build(
        :event, name: 'Formação de Padeiros', user: user, status: 'published', categories: [ other_category ]
      )
      other_event.logo.attach(io: File.open('spec/support/images/logo.jpg'), filename: 'logo.jpg', content_type: 'img/jpg')
      other_event.banner.attach(io: File.open('spec/support/images/banner.png'), filename: 'banner.png', content_type: 'img/png')
      other_event.save


      get '/api/v1/events', params: { query: 'programming' }

      expect(response).to have_http_status :success
      expect(response.content_type).to include('application/json')
      expect(response.parsed_body['events'][0]['name']).to include('Formação de Churrasqueiros')
      expect(response.parsed_body['events'][0]['address']).to include("#{event.event_place.street}, #{event.event_place.number}")
      expect(response.parsed_body['events'][0]['description']).to include(event.description.to_plain_text)
      expect(response.parsed_body['events'][0]['code']).to eq event.code
      expect(response.parsed_body['events'][0]['logo_url']).to eq url_for(event.logo)
      expect(response.parsed_body['events'][0]['banner_url']).to eq url_for(event.banner)
      expect(response.parsed_body['events'][0]['participants_limit']).to eq event.participants_limit
      expect(response.parsed_body['events'][0]['event_owner']).to eq event.user.name
      expect(response.parsed_body['events'][0]['start_date']).to eq event.start_date.iso8601(3)
      expect(response.parsed_body['events'][0]['end_date']).to eq event.end_date.iso8601(3)
      expect(response.parsed_body['events'].count).to eq 1
    end

    it 'e não acha eventos, retorna vazio pois não tem nada relacionado a busca' do
      user = create(:user)

      category = Category.create!(name: 'Palestra')
      keyword = Keyword.create!(value: 'programming')

      CategoryKeyword.create!(category: category, keyword: keyword)

      event = build(
        :event, name: 'Formação de Churrasqueiros', user: user, status: 'published',
        categories: [ category ])

      event.logo.attach(io: File.open('spec/support/images/logo.jpg'), filename: 'logo.jpg', content_type: 'img/jpg')
      event.banner.attach(io: File.open('spec/support/images/banner.png'), filename: 'banner.png', content_type: 'img/png')

      event.save

      get '/api/v1/events', params: { query: 'BuscarQualquerQueNãoExiste' }

      expect(response).to have_http_status :success
      expect(response.content_type).to include('application/json')
      expect(response.parsed_body['events'].count).to eq 0
    end
  end

  context 'Usuário ve detalhes' do
    it 'com sucesso' do
      user = create(:user)
      event = build(:event, user: user, status: 'published',
        name: 'Formação de Churrasqueiros',
        description: 'Aprenda a fazer churrasco como um profissional',
        event_type: :inperson,
        event_place: create(:event_place, user: user, street: 'Rua das Laranjeiras', number: '123'),
        participants_limit: 30,
        start_date:  (Time.now + 3.day).change(hour: 8, min: 0, sec: 0),
        end_date: (Time.now + 4.day).change(hour: 18, min: 0, sec: 0)
        )
        event.logo.attach(io: File.open('spec/support/images/logo.jpg'), filename: 'logo.jpg', content_type: 'img/png')
        event.banner.attach(io: File.open('spec/support/images/banner.png'), filename: 'banner.png', content_type: 'img/jpg')
      event.save
      schedule = event.schedules.first
      ticket_batch = create(:ticket_batch, event: event,
        start_date:  (Time.now + 1.day).change(hour: 8, min: 0, sec: 0),
        end_date: (Time.now + 2.day).change(hour: 18, min: 0, sec: 0))
      coffee_break = create(:schedule_item, schedule: schedule, name: 'Coffee Break',
        start_time: (Time.now + 1.day).change(hour: 9, min: 0, sec: 0),
        end_time: (Time.now + 1.day).change(hour: 10, min: 0, sec: 0))
      music_lesson = create(:schedule_item, schedule: schedule, name: 'Aula de música',
        start_time: (Time.now + 1.day).change(hour: 10, min: 0, sec: 0),
        end_time: (Time.now + 1.day).change(hour: 11, min: 0, sec: 0))

      get "/api/v1/events/#{event.code}"

      expect(response).to have_http_status :success
      expect(response.content_type).to include('application/json')
      expect(response.parsed_body['code']).to eq event.code
      expect(response.parsed_body['name']).to include('Formação de Churrasqueiros')
      expect(response.parsed_body['description']).to include(event.description.body.to_html)
      expect(response.parsed_body['event_type']).to include('inperson')
      expect(response.parsed_body['address']).to include('Rua das Laranjeiras, 123')
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
      expect(response.parsed_body['schedules'][0]['schedule_items'][0]['code']).to eq coffee_break.code
      expect(response.parsed_body['schedules'][0]['schedule_items'][0]['name']).to eq coffee_break.name
      expect(response.parsed_body['schedules'][0]['schedule_items'][0]['description']).to eq coffee_break.description
      expect(response.parsed_body['schedules'][0]['schedule_items'][0]['responsible_name']).to eq coffee_break.responsible_name
      expect(response.parsed_body['schedules'][0]['schedule_items'][0]['responsible_email']).to eq coffee_break.responsible_email
      expect(response.parsed_body['schedules'][0]['schedule_items'][0]['schedule_type']).to eq coffee_break.schedule_type
      expect(response.parsed_body['schedules'][0]['schedule_items'][1]['name']).to eq music_lesson.name
      expect(response.parsed_body['schedules'][0]['schedule_items'][1]['code']).to eq music_lesson.code
    end

    it 'e se o evento for online, não vê o endereço' do
      user = create(:user)
      event = build(:event, user: user, status: 'published',
        name: 'Formação de Churrasqueiros',
        description: 'Aprenda a fazer churrasco como um profissional',
        event_type: :online,
        participants_limit: 30,
        start_date:  (Time.now + 3.day).change(hour: 8, min: 0, sec: 0),
        end_date: (Time.now + 4.day).change(hour: 18, min: 0, sec: 0)
        )
        event.logo.attach(io: File.open('spec/support/images/logo.jpg'), filename: 'logo.jpg', content_type: 'img/png')
        event.banner.attach(io: File.open('spec/support/images/banner.png'), filename: 'banner.png', content_type: 'img/jpg')
      event.save

      get "/api/v1/events/#{event.code}"

      expect(response).to have_http_status :success
      expect(response.content_type).to include('application/json')
      expect(response.parsed_body['code']).to eq event.code
      expect(response.parsed_body['name']).to include('Formação de Churrasqueiros')
      expect(response.parsed_body['description']).to include(event.description.body.to_html)
      expect(response.parsed_body['event_type']).to include('online')
      expect(response.parsed_body).not_to have_key('address')
    end

    it "e evento não existe" do
      get "/api/v1/events/WRONG_CODE"

      expect(response).to have_http_status :not_found
      expect(response.content_type).to include('application/json')
    end
  end
end
