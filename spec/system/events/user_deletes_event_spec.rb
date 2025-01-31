require 'rails_helper'

describe 'Usuário deleta um evento' do
  it 'com sucesso' do
    user = create(:user)
    category = create(:category, name: 'Tecnologia')
    event1 = create(:event, name: 'Introdução ao RoR', user: user, categories: [ category ])
    create(:event, name: 'CCXP', user: user, categories: [ category ])

    login_as user
    visit root_path
    find("button[data-test-id='delete-#{event1.id}']").click

    expect(page).to have_content 'Evento deletado com sucesso'
    expect(page).not_to have_content 'Introdução ao RoR'
  end
end
