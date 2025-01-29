require 'rails_helper'

RSpec.describe TicketBatch, type: :model do
  describe '#valid?' do
    context 'presença dos atributos' do
      it 'falha quando o nome está vazio' do
        ticket_batch = build(:ticket_batch, name: '')

        expect(ticket_batch).not_to be_valid
        expect(ticket_batch.errors[:name]).to include 'não pode ficar em branco'
      end

      it 'falha quando o limite de ingressos do lote está vazio' do
        ticket_batch = build(:ticket_batch, tickets_limit: nil)

        expect(ticket_batch).not_to be_valid
        expect(ticket_batch.errors[:tickets_limit]).to include 'não pode ficar em branco'
      end

      it 'falha quando o data de inicio está vazia' do
        ticket_batch = build(:ticket_batch, start_date: '')

        expect(ticket_batch).not_to be_valid
        expect(ticket_batch.errors[:start_date]).to include 'não pode ficar em branco'
      end

      it 'falha quando o valor dos ingressos está vazio' do
        ticket_batch = build(:ticket_batch, ticket_price: nil)

        expect(ticket_batch).not_to be_valid
        expect(ticket_batch.errors[:ticket_price]).to include 'não pode ficar em branco'
      end

      it 'falha quando a opção de descontos está vazia' do
        ticket_batch = build(:ticket_batch, discount_option: nil)

        expect(ticket_batch).not_to be_valid
        expect(ticket_batch.errors[:discount_option]).to include 'não pode ficar em branco'
      end
    end

    context 'comparacao das datas' do
      it 'data de inicio deve ser menor que a data de fim' do
        ticket_batch = build(:ticket_batch, start_date: (Time.now + 8.days).strftime('%Y-%m-%d'), end_date: (Time.now + 5.days).strftime('%Y-%m-%d'))

        expect(ticket_batch).not_to be_valid
        expect(ticket_batch.errors[:start_date]).to include 'não pode ser depois da data de fim'
      end
    end

    context 'atribuição automática' do
      it 'quando não é definida a data final' do
        event = create(:event,
          start_date: (Time.now + 1.day),
          end_date: (Time.now + 3.day).strftime('%Y-%m-%d')
        )
        ticket_batch = create(:ticket_batch, end_date: nil, event: event)

        expect(ticket_batch.end_date).to eq event.start_date.to_date
      end

      it 'quando não é definido um tipo de desconto' do
        event = create(:event)
        ticket_batch = TicketBatch.create!(
          name: 'Primeiro lote',
          tickets_limit: 20,
          start_date: 3.days.from_now.strftime('%Y-%m-%d'),
          end_date: 3.months.from_now.strftime('%Y-%m-%d'),
          ticket_price: 100,
          event: event
        )

        expect(ticket_batch.discount_option).to eq "no_discount"
      end

      it 'de meia entrada no valor do ingresso' do
        ticket_batch = create(:ticket_batch, ticket_price: 1000, discount_option: :student)

        expect(ticket_batch.ticket_price).to eq 500
      end
    end

    context 'limitação automática' do
      it 'quando supera limite de participantes do evento' do
        create(:ticket_batch, tickets_limit: 20)
        event = Event.last
        ticket_batch = build(:ticket_batch, tickets_limit: 11, event: event)

        expect(ticket_batch).not_to be_valid
      end
    end
  end
end