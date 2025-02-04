require 'rails_helper'

RSpec.describe UserAddress, type: :model do
  describe '#valid?' do
    context 'presenca' do
      it 'deve ter uma rua' do
        user_address = build(:user_address, street: nil)
        user_address.valid?

        expect(user_address.errors).to include(:street)
        expect(user_address).not_to be_valid
      end

      it 'deve ter um numero' do
        user_address = build(:user_address, number: nil)
        user_address.valid?

        expect(user_address.errors).to include(:number)
        expect(user_address).not_to be_valid
      end

      it 'deve ter um bairro' do
        user_address = build(:user_address, district: nil)
        user_address.valid?

        expect(user_address.errors).to include(:district)
        expect(user_address).not_to be_valid
      end

      it 'deve ter uma cidade' do
        user_address = build(:user_address, city: nil)
        user_address.valid?

        expect(user_address.errors).to include(:city)
        expect(user_address).not_to be_valid
      end

      it 'deve ter um estado' do
        user_address = build(:user_address, state: nil)
        user_address.valid?

        expect(user_address.errors).to include(:state)
        expect(user_address).not_to be_valid
      end

      it 'deve ter um cep' do
        user_address = build(:user_address, zip_code: nil)
        user_address.valid?

        expect(user_address.errors).to include(:zip_code)
        expect(user_address).not_to be_valid
      end
    end

    context 'numeralidade' do
      it 'numero deve ser um inteiro' do
        user_address = build(:user_address, number: 3.5)
        user_address.valid?

        expect(user_address.errors).to include(:number)
        expect(user_address).not_to be_valid
      end

      it 'deve ser maior que 0' do
        user_address = build(:user_address, number: -5)
        user_address.valid?

        expect(user_address.errors).to include(:number)
        expect(user_address).not_to be_valid
      end
    end

    context 'tamanho da string de estado' do
      it 'deve ser exatamente igual a 2' do
        user_address = build(:user_address, state: 'MGC')
        user_address.valid?

        expect(user_address.errors).to include(:state)
        expect(user_address).not_to be_valid
      end

      it 'deve ser um dos estados existentes' do
        user_address = build(:user_address, state: 'MZ')
        user_address.valid?

        expect(user_address.errors).to include(:state)
        expect(user_address).not_to be_valid
      end
    end
  end
end
