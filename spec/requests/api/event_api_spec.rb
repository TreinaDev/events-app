require 'rails_helper'

describe 'Event API' do
  context 'Get /api/v1/events' do
    it 'success' do
      user = create(:user)

      category = Category.create!(name: 'Palestra')

      event = create(
        :event, name: 'Formação de Churrasqueiros', user: user, status: 'published',
        address: 'Rua das Laranjeiras, 123', description: 'Aprenda a fazer churrasco como um profissional')

      draft_event = create(
          :event, name: 'Formação de Padeiros', user: user, status: 'draft',
          address: 'Rua dos ipês, 343', description: 'Aprenda a fazer Pão como um profissional', categories: [ category ])

      get '/api/v1/events'

      expect(response).to have_http_status :success
      expect(response.content_type).to include('application/json')
      expect(response.parsed_body['events'][0]['name']).to include(event.name)
      expect(response.parsed_body['events'][0]['address']).to include(event.address)
      expect(response.parsed_body['events'][0]['description']).to include(event.description.body.to_html)
      expect(response.parsed_body['events'][0]['id']).to eq event.id
      expect(response.parsed_body['events']).not_to include(draft_event.name)
      expect(response.parsed_body['events']).not_to include(draft_event.address)
      expect(response.parsed_body['events']).not_to include(draft_event.description)
      expect(response.parsed_body['events']).not_to include(draft_event.id)
    end
  end
end
