require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    context 'presenca' do
      it 'deve ter um nome' do
        user = User.new()
        user.valid?

        expect(user.errors).to include(:name)
        expect(user).not_to be_valid
      end

      it 'deve ter um sobrenome' do
        user = User.new()
        user.valid?

        expect(user.errors).to include(:family_name)
        expect(user).not_to be_valid
      end

      it 'deve ter um CPF' do
        user = User.new()
        user.valid?

        expect(user.errors).to include(:registration_number)
        expect(user).not_to be_valid
      end
    end

    context '#uniqueness' do
      it 'deve ter um CPF Unico' do
        registration_number = CPF.generate
        User.create!(email: 'wg0Hl@example.com', password: 'password123',
          name: 'Alice', family_name: 'Moreno',
          registration_number: registration_number
        )
        second_user = User.new(email: 'outroemail@example.com', password: 'password123',
          name: 'Alice', family_name: 'Moreno',
          registration_number: registration_number
        )

        second_user.valid?

        expect(second_user.errors).to include(:registration_number)
        expect(second_user).not_to be_valid
      end
    end

    context '#CPF Válido' do
      it 'deve se enquadrar no padrão válido' do
        user = User.new(
          name: 'Luan',
          family_name: 'Carvalho',
          registration_number: '00000000000',
          email: 'luan@email.com',
          password: 'fortissima12'
        )

        user.valid?

        expect(user.errors).to include(:registration_number)
        expect(user).not_to be_valid
      end
    end
  end

  describe 'recebe um status padrão de não verificado' do
    it 'quando criado' do
      user = User.new(
        name: 'Luan',
        family_name: 'Carvalho',
        registration_number: CPF.generate,
        email: 'luan@email.com',
        password: 'fortissima12'
      )

      expect(user.verification_status).to eq("unverified")
    end
  end

  describe 'recebe um tipo de usuario' do
    it 'de event_manager quando cria uma conta com email de outro domínio' do
      user = User.new(
        name: 'Luan',
        family_name: 'Carvalho',
        registration_number: CPF.generate,
        email: 'luan@email.com',
        password: 'fortissima12'
      )

      expect(user.role).to eq("event_manager")
    end

    it 'de admin quando cria uma conta com email de dominio @meuevento.com.br' do
      user = User.create!(
        name: 'Luan',
        family_name: 'Carvalho',
        registration_number: CPF.generate,
        email: 'luan@meuevento.com.br',
        password: 'fortissima12'
      )

      expect(user.role).to eq("admin")
    end
  end
end
