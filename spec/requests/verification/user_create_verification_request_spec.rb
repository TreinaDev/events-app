require 'rails_helper'

describe 'Usuário cria verificação' do
  context 'sem autorização' do
    it 'e falha por não estar autenticado' do
      create(:user)

      post verifications_path(
        user: {
          address: {
            street: 'Rua Judite dos Santos',
            number: '522',
            district: 'Centro',
            city: 'São Paulo',
            state: 'SP',
            zip_code: '01000-000'
          },
          id_photo: Rails.root.join('spec/support/images/id_photo.png'),
          address_proof: Rails.root.join('spec/support/images/residency_proof.jpeg')
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
          address: {
            street: 'Rua Judite dos Santos',
            number: '522',
            district: 'Centro',
            city: 'São Paulo',
            state: 'SP',
            zip_code: '01000-000'
          },
          id_photo: Rails.root.join('spec/support/images/id_photo.png'),
          address_proof: Rails.root.join('spec/support/images/residency_proof.jpeg')
        }
      )

      expect(response).to redirect_to dashboard_path
      expect(response).to have_http_status :found
    end
  end

  context 'e falha' do
    it 'por não informar todos os dados necessários' do
      user = create(:user)
      login_as user

      post verifications_path(
        user: {
          address: {
            street: 'Rua Judite dos Santos',
            number: '522',
            district: 'Centro',
            city: 'São Paulo',
            state: 'SP',
            zip_code: '01000-000'
          },
          id_photo: nil,
          address_proof: Rails.root.join('spec/support/images/residency_proof.jpeg')
        }
      )

      user.reload
      expect(response).to have_http_status :unprocessable_entity
    end
  end
end
