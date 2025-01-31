require 'rails_helper'

describe 'Usuário visualiza eventos' do
  it 'com sucesso' do
    user = create(:user, email: 'teste@email.com')
    category = create(:category, name: 'Tecnologia')
    create(:event, name: 'ccxp', status: :published, user: user, categories: [ category ])
    create(:event, name: 'Introdução ao RoR', user: user, categories: [ category ])

    login_as user
    visit root_path

    expect(page).to have_content 'ccxp'
    expect(page).to have_content 'Introdução ao RoR'
  end

  it 'e não está autenticado' do
    user = create(:user, email: 'teste@email.com')
    category = create(:category, name: 'Tecnologia')
    create(:event, name: 'ccxp', status: :published, user: user, categories: [ category ])
    create(:event, name: 'Introdução ao RoR', user: user, categories: [ category ])

    visit root_path

    expect(page).not_to have_content 'Introdução ao RoR'
  end

  it 'e não consegue visualizar os eventos do outro' do
    user = create(:user, email: 'teste@email.com')
    category = create(:category, name: 'Tecnologia')
    create(:event, name: 'ccxp', status: :published, user: user, categories: [ category ])
    marcelo = create(:user, email: 'marcelo@email.com')
    create(:event, name: 'Introdução ao RoR', user: marcelo, categories: [ category ])

    login_as marcelo
    visit root_path

    expect(page).not_to have_content 'ccxp'
    expect(page).to have_content 'Introdução ao RoR'
  end
end
