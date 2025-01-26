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

    context 'atribuição automática' do
      it 'quando não é definida a data final' do
        schedule = create(:schedule, start_date: (Time.now + 1.day).change(hour: 8, min: 0, sec: 0).strftime('%Y-%m-%d'))
        ticket_batch = create(:ticket_batch, end_date: nil, event: schedule.event)

        expect(ticket_batch.end_date).to eq schedule.start_date
      end

      it 'quando é escolhida uma opção de desconto' do
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
