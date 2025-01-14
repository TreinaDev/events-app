require 'rails_helper'

describe 'User visits event creation pagr' do
  it 'and is not authenticated' do
    visit root_path
    click_on 'Eventos'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'is authenticate' do
    # ERRO: Could not find a valid mapping for #<User

    user = User.create!(email: 'user@email.com', name: 'user', family_name: 'last name', password: 'senha123', registration_number: '20990882098', role: 'user')

    login_as user

    visit root_path

    expect(page).to have_content 'Eventos'
  end
end
