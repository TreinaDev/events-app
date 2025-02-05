require 'rails_helper'

RSpec.describe EventPlaceRecommendation, type: :model do
  describe '#valid?' do
    it 'falha quando o nome está vazio' do
      event_place_recommendation = EventPlaceRecommendation.new(name: '')
      event_place_recommendation.valid?
      expect(event_place_recommendation.errors[:name]).to include 'não pode ficar em branco'
    end

    it 'falha quando o endereço completo está vazio' do
      event_place_recommendation = EventPlaceRecommendation.new(full_address: '')
      event_place_recommendation.valid?
      expect(event_place_recommendation.errors[:full_address]).to include 'não pode ficar em branco'
    end

    it 'falha quando o telefone é menor que 10 caracteres' do
      event_place_recommendation = EventPlaceRecommendation.new(phone: '123')
      event_place_recommendation.valid?
      expect(event_place_recommendation.errors[:phone]).to include 'é muito curto (mínimo: 10 caracteres)'
    end

    it 'falha quando o telefone é maior que 11 caracteres' do
      event_place_recommendation = EventPlaceRecommendation.new(phone: '1234567890123')
      event_place_recommendation.valid?
      expect(event_place_recommendation.errors[:phone]).to include 'é muito longo (máximo: 11 caracteres)'
    end

    it 'falha quando o telefone contém letras' do
      event_place_recommendation = EventPlaceRecommendation.new(phone: '12b4567890a')
      event_place_recommendation.valid?
      expect(event_place_recommendation.errors[:phone]).to include 'não é um número'
    end

    it 'é valido quando todos os atributos forem preenchidos corretamente' do
      evente_place = create(:event_place)
      event_place_recommendation = EventPlaceRecommendation.new(name: 'Recomendação de Local',
        full_address: 'Endereço Completo', phone: '1234567890', event_place: evente_place
      )
      expect(event_place_recommendation).to be_valid
    end
  end
end
