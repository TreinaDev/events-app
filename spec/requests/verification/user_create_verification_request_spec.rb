require 'rails_helper'

describe 'Usuário cria verificação' do
  context 'sem autorização' do
    it 'e falha por não estar autenticado' do
      create(:user)

      post verifications_path(
        user: {
          user_address_attributes: {
            street: 'Rua Judite dos Santos',
            number: '522',
            district: 'Centro',
            city: 'São Paulo',
            state: 'SP',
            zip_code: '01000-000'
          },
          id_photo: '',
          address_proof: '',
          phone_number: ''
        }
      )

      expect(response).to redirect_to new_user_session_path
      expect(response).to have_http_status :found
    end

    it 'e falha por não ser event_manager' do
      admin = create(:user, :admin)
      login_as admin

      post verifications_path(
        user: {
          user_address_attributes: {
            street: 'Rua Judite dos Santos',
            number: '522',
            district: 'Centro',
            city: 'São Paulo',
            state: 'SP',
            zip_code: '01000-000'
          },
          id_photo: '',
          address_proof: '',
          phone_number: ''
        }
      )

      expect(response).to redirect_to dashboard_path
      expect(response).to have_http_status :found
    end
  end

  context 'e falha' do
    it 'por não informar todos os dados necessários (inclusive os que sao opcionais na criaçao de user)' do
      user = create(:user)
      login_as user

      post verifications_path(
        user: {
          user_address_attributes: {
            street: 'Rua Judite dos Santos',
            number: '522',
            district: 'Centro',
            city: 'São Paulo',
            state: 'SP',
            zip_code: '01000-000'
          },
          id_photo: '',
          address_proof: '',
          phone_number: ''
        }
      )

      expect(response).to have_http_status :unprocessable_entity
    end

    it 'por já ser um usuário verificado' do
      user = create(:user, verification_status: :verified)
      login_as user

      post verifications_path(
        user: {
          user_address_attributes: {
            street: 'Rua Judite dos Santos',
            number: '522',
            district: 'Centro',
            city: 'São Paulo',
            state: 'SP',
            zip_code: '01000-000'
          }
        }
      )

      expect(response).to redirect_to dashboard_path
      expect(response).to have_http_status :found
      puts response.body
      expect(flash[:alert]).to eq('Usuário já possui status verificado')
    end
  end
end
