require 'rails_helper'

describe 'Usuário deleta um evento' do
  it 'com sucesso' do
    user = create(:user)
    category = create(:category, name: 'Tecnologia')
    create(:event, name: 'Introdução ao RoR', user: user, categories: [ category ])
    create(:event, name: 'CCXP', user: user, categories: [ category ])

    login_as user
    visit events_path
    within 'div.card-body', text: 'Introdução ao RoR' do
      accept_confirm do
        click_on 'Deletar'
      end
    end

    expect(page).to have_content 'Evento deletado com sucesso'
    expect(page).not_to have_content 'Introdução ao RoR'
  end
end
