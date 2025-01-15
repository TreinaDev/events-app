require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'should have a name' do
        user = User.new()
        user.valid?

        expect(user.errors.include?(:name)).to be true
        expect(user).not_to be_valid
      end

      it 'should have a family name' do
        user = User.new()
        user.valid?

        expect(user.errors.include?(:family_name)).to be true
        expect(user).not_to be_valid
      end

      it 'should have a registration number' do
        user = User.new()
        user.valid?

        expect(user.errors.include?(:registration_number)).to be true
        expect(user).not_to be_valid
      end
    end

    context '#uniqueness' do
      it 'should have a unique registration number' do
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

        expect(second_user.errors.include?(:registration_number)).to be true
        expect(second_user).not_to be_valid
      end
    end

    context '#registration number validity' do
      it 'should match the pattern' do
        user = User.new(
          name: 'Luan',
          family_name: 'Carvalho',
          registration_number: '00000000000',
          email: 'luan@email.com',
          password: 'fortissima12'
        )

        user.valid?

        expect(user.errors.include?(:registration_number)).to be true
        expect(user).not_to be_valid
      end
    end
  end

  describe 'receive a standard status not verified' do
    it 'when created' do
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

  describe 'receive a role' do
    it 'of event_manager when creating with any other email domain' do
      user = User.new(
        name: 'Luan',
        family_name: 'Carvalho',
        registration_number: CPF.generate,
        email: 'luan@email.com',
        password: 'fortissima12'
      )

      expect(user.role).to eq("event_manager")
    end

    it 'of admin when creating with a @meuevento.com.br email' do
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
