require 'rails_helper'

describe 'Usuário edita event places' do
  it 'e nao esta autenticado' do
    event_place = create(:event_place)

    visit edit_event_place_path(event_place)

    expect(current_path).to eq new_user_session_path
  end

  it 'outro usuario nao consegue editar e é redirecionado' do
    user = create(:user)
    event_place = create(:event_place, user: user)

    other_user = create(:user, email: 'outro_user@email.com', password: 'password123')
    login_as other_user

    visit edit_event_place_path(event_place)

    expect(current_path).to eq event_places_path
  end

  it 'se nao existe o event place deve ser redirecionado' do
    user = create(:user)
    login_as user

    visit edit_event_place_path(999)

    expect(current_path).to eq event_places_path
  end

  it 'consegue acessar a página de edição' do
    user = create(:user)
    event_place = create(:event_place, user: user)
    login_as user

    visit edit_event_place_path(event_place)

    expect(page).to have_content 'Editar Local de Evento'
    expect(page).to have_field 'Nome', with: event_place.name
    expect(page).to have_field 'Rua', with: event_place.street
    expect(page).to have_field 'Número', with: event_place.number
    expect(page).to have_field 'Bairro', with: event_place.neighborhood
    expect(page).to have_field 'Cidade', with: event_place.city
    expect(page).to have_field 'CEP', with: event_place.zip_code
  end

  it 'consegue editar um event place' do
    user = create(:user)
    event_place = create(:event_place, user: user)
    login_as user

    visit edit_event_place_path(event_place)

    fill_in 'Nome', with: 'Novo nome'
    fill_in 'Rua', with: 'Nova rua'
    fill_in 'Bairro', with: 'Novo bairro'
    fill_in 'Cidade', with: 'Nova cidade'
    fill_in 'CEP', with: '99999999'
    click_on 'Atualizar'

    expect(current_path).to eq event_place_path(event_place)

    expect(page).to have_content 'Local de Evento atualizado com sucesso.'
    expect(page).to have_content 'Novo nome'
    expect(page).to have_content 'Nova rua'
    expect(page).to have_content 'Novo bairro'
    expect(page).to have_content 'Nova cidade'
    expect(page).to have_content '99999999'
  end

  it 'e falha devido aos campos obrigatórios estar em branco' do
    user = create(:user)
    event_place = create(:event_place, user: user)
    login_as user

    visit edit_event_place_path(event_place)

    fill_in 'Nome', with: ''
    fill_in 'Rua', with: ''
    fill_in 'Bairro', with: ''
    fill_in 'Cidade', with: ''
    fill_in 'CEP', with: ''
    click_on 'Atualizar'

    expect(page).to have_content 'Falha ao atualizar o Local de Evento'

    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Rua não pode ficar em branco'
    expect(page).to have_content 'Bairro não pode ficar em branco'
    expect(page).to have_content 'Cidade não pode ficar em branco'
    expect(page).to have_content 'CEP não pode ficar em branco'
  end
end
