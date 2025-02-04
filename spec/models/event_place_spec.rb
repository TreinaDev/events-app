require 'rails_helper'

RSpec.describe EventPlace, type: :model do
  describe '#valid?' do
    context 'presenca' do
      it 'é valido quando todos os atributos obrigatórios forem preenchidos corretamente' do
        user = create(:user)
        event_place = EventPlace.new(user: user, name: 'Event Place', street: 'Rua 1',
          number: '123', neighborhood: 'Bairro', city: 'Cidade', state: 'Estado',
          zip_code: '12345-678'
        )
        expect(event_place).to be_valid
      end

      it 'falha quando o nome está vazio' do
        event_place = EventPlace.new(name: '')
        event_place.valid?
        expect(event_place.errors[:name]).to include 'não pode ficar em branco'
      end

      it 'falha quando a rua está vazia' do
        event_place = EventPlace.new(street: '')
        event_place.valid?
        expect(event_place.errors[:street]).to include 'não pode ficar em branco'
      end

      it 'falha quando o número está vazio' do
        event_place = EventPlace.new(number: '')
        event_place.valid?
        expect(event_place.errors[:number]).to include 'não pode ficar em branco'
      end

      it 'falha quando a cidade está vazia' do
        event_place = EventPlace.new(city: '')
        event_place.valid?
        expect(event_place.errors[:city]).to include 'não pode ficar em branco'
      end

      it 'falha quando o estado está vazio' do
        event_place = EventPlace.new(state: '')
        event_place.valid?
        expect(event_place.errors[:state]).to include 'não pode ficar em branco'
      end

      it 'falha quando o cep está vazio' do
        event_place = EventPlace.new(zip_code: '')
        event_place.valid?
        expect(event_place.errors[:zip_code]).to include 'não pode ficar em branco'
      end

      it 'falha quando o bairro está vazio' do
        event_place = EventPlace.new(neighborhood: '')
        event_place.valid?
        expect(event_place.errors[:neighborhood]).to include 'não pode ficar em branco'
      end
    end

    context 'association' do
      it 'deve ter um user' do
        event_place = EventPlace.new(user: nil)
        event_place.valid?
        expect(event_place.errors[:user]).to include 'é obrigatório(a)'
      end
    end
  end
end
