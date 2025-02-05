require 'rails_helper'

describe 'Usuário visita a tela de visualizar solicitações de verificação' do
  it 'e não está autenticado' do
    visit verifications_path

    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'e está autenticado' do
    user = create(:user)

    login_as user

    visit verifications_path

    expect(page).to have_content 'Minhas Solicitações de Verificação'
  end

  context 'como gerenciador de eventos' do
    it 'e ve todas suas solicitações' do
      user = create(:user, :with_pending_request)
      denied_verification_request = create(:verification, user: user, status: 'rejected', comment: 'A foto do CPF está muito ruim, não é possível enxergar os dados')
      login_as user

      visit root_path
      within "[data-controller='user-options']" do
        click_on 'Consultar reqs. de verificação'
      end

      within 'section' do
        expect(page).to have_selector "article", count: 2
        expect(page).to have_content Verification.human_enum_name(:status, user.verifications.first.status)
        expect(page).to have_content Verification.human_enum_name(:status, denied_verification_request.status)
        expect(page).to have_content I18n.l(user.verifications.first.created_at, format: :short)
        expect(page).to have_content I18n.l(denied_verification_request.created_at, format: :short)
        expect(page).to have_content "Comentário: #{denied_verification_request.comment}"
      end
      expect(current_path).to eq verifications_path
    end

  context 'como admin' do
      it 'e ve todas solicitações pendentes' do
        user = create(:user, :with_pending_request)
        second_user = create(:user, :with_pending_request, email: 'second@user.com')
        admin = create(:user, :admin)
        login_as admin

        visit root_path
        within "[data-controller='user-options']" do
          click_on 'Consultar reqs. de verificação'
        end

        within 'section' do
          expect(page).to have_selector "article", count: 2
          expect(page).to have_content "Solicitação #1 - Enviada por #{user.name } em #{I18n.l user.verifications.first.created_at, format: :short }"
          expect(page).to have_content "Solicitação #2 - Enviada por #{second_user.name } em #{I18n.l second_user.verifications.first.created_at, format: :short }"
        end
        expect(current_path).to eq verifications_path
      end
    end
  end
end
