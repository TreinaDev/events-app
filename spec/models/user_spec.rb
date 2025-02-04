require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    context 'presenca' do
      it 'deve ter um nome' do
        user = build(:user, name: nil)
        user.valid?

        expect(user.errors).to include(:name)
        expect(user).not_to be_valid
      end

      it 'deve ter um sobrenome' do
        user = build(:user, family_name: nil)
        user.valid?

        expect(user.errors).to include(:family_name)
        expect(user).not_to be_valid
      end

      it 'deve ter um CPF' do
        user = build(:user, registration_number: nil)
        user.valid?

        expect(user.errors).to include(:registration_number)
        expect(user).not_to be_valid
      end
    end

    context '#uniqueness' do
      it 'deve ter um CPF Unico' do
        registration_number = CPF.generate
        create(:user, registration_number: registration_number)
        second_user = build(:user, email: 'outroemail@example.com', registration_number: registration_number)

        second_user.valid?

        expect(second_user.errors).to include(:registration_number)
        expect(second_user).not_to be_valid
      end
    end

    context '#CPF Válido' do
      it 'deve se enquadrar no padrão válido' do
        user = build(:user, registration_number: '00000000000')

        user.valid?

        expect(user.errors).to include(:registration_number)
        expect(user).not_to be_valid
      end
    end

    context 'tipo dos arquivos da verificacao' do
      it 'deve ser .pdf, .jpg, .jpeg, .png, .doc, .docx para foto do documento de identidade' do
        temporary_file = Tempfile.new([ 'empty_document', '.txt' ])
        user = build(:user)
        user.id_photo.attach(io: temporary_file, filename: 'empty_document.txt', content_type: 'text/plain')
        user.valid?

        expect(user.errors).to include(:id_photo)
        expect(user).not_to be_valid
      end

      it 'deve ser .pdf, .jpg, .jpeg, .png, .doc, .docx para foto do comprovante de residencia' do
        temporary_file = Tempfile.new([ 'empty_document', '.txt' ])
        user = build(:user)
        user.address_proof.attach(io: temporary_file, filename: 'empty_document.txt', content_type: 'text/plain')
        user.valid?

        expect(user.errors).to include(:address_proof)
        expect(user).not_to be_valid
      end
    end
  end

  describe 'recebe um status' do
    it 'padrão de não verificado quando criado' do
      user = build(:user)

      expect(user.verification_status).to eq("unverified")
    end

    it 'de verificado quando confirma sua conta de admin' do
      user = build(:user, email: 'luan@meuevento.com.br')

      user.confirm

      expect(user.verification_status).to eq("verified")
    end
  end

  describe 'recebe um tipo de usuario' do
    it 'de event_manager quando cria uma conta com email de outro domínio' do
      user = build(:user)

      expect(user.role).to eq("event_manager")
    end

    it 'de admin quando cria uma conta com email de dominio @meuevento.com.br' do
      user = build(:user, email: 'luan@meuevento.com.br')

      user.confirm

      expect(user.role).to eq("admin")
    end
  end
end
