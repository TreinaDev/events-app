require 'rails_helper'

describe 'Ticket Batch API' do
  context 'Usuário ve a lista de ticket batches de um evento' do
    it 'com sucesso' do
      user = create(:user)
      event = create(:event, user: user)
      create(:ticket_batch, name: 'Primeiro Lote', tickets_limit: 15, event: event)
      create(:ticket_batch, name: 'Segundo Lote', tickets_limit: 20, event: event)

      get "/api/v1/events/#{event.code}/ticket_batches"

      expect(response).to have_http_status :ok
      expect(response.content_type).to include('application/json')

      ticket_batches = JSON.parse(response.body, symbolize_names: true)

      expect(ticket_batches[:ticket_batches].length).to eq(2)
      expect(ticket_batches[:ticket_batches][0][:name]).to eq('Primeiro Lote')
      expect(ticket_batches[:ticket_batches][0][:tickets_limit]).to eq(15)
      expect(ticket_batches[:ticket_batches][1][:name]).to eq('Segundo Lote')
      expect(ticket_batches[:ticket_batches][1][:tickets_limit]).to eq(20)
    end
  end

  context 'Usuário ve detalhes de ticket batch de um evento' do
    it 'com sucesso' do
      user = create(:user)
      event = create(:event, user: user)
      ticket_batch = create(:ticket_batch, name: 'Primeiro Lote', tickets_limit: 15,
        start_date: 2.days.from_now, end_date: 3.days.from_now, ticket_price: 1000,
        discount_option: :student, event: event
      )

      get "/api/v1/events/#{event.code}/ticket_batches/#{ticket_batch.id}"

      expect(response).to have_http_status :ok
      expect(response.content_type).to include('application/json')

      ticket_batch = JSON.parse(response.body, symbolize_names: true)

      expect(ticket_batch[:ticket_batch][:name]).to eq('Primeiro Lote')
      expect(ticket_batch[:ticket_batch][:tickets_limit]).to eq(15)
      expect(ticket_batch[:ticket_batch][:start_date]).to eq(2.days.from_now.strftime('%Y-%m-%d'))
      expect(ticket_batch[:ticket_batch][:end_date]).to eq(3.days.from_now.strftime('%Y-%m-%d'))
      expect(ticket_batch[:ticket_batch][:ticket_price]).to eq("500.0")
      expect(ticket_batch[:ticket_batch][:discount_option]).to eq("student")
    end

    it 'e falha caso o ticket batch nao seja encontrado' do
      user = create(:user)
      event = create(:event, user: user)
      create(:ticket_batch, name: 'Primeiro Lote', tickets_limit: 15, event: event)

      get "/api/v1/events/#{event.code}/ticket_batches/WRONG_ID"

      expect(response).to have_http_status :not_found
      expect(response.content_type).to include('application/json')
      expect(response.body).to include("Ticket batch not found")
    end
  end
end
