require 'rails_helper'

describe 'Usuário edita horários do evento' do
  it 'com sucesso' do
    user = create(:user)
    event = create(:event, user: user)
    create(:schedule, event: event)

    login_as user
    visit root_path
    click_on 'Meus eventos'
    click_on "#{event.name}"
    click_on 'Editar horário'
    fill_in 'Data de início', with: (Time.now + 3.day).change(hour: 8, min: 0, sec: 0)
    fill_in 'Data de fim', with: (Time.now + 4.day).change(hour: 8, min: 0, sec: 0)
    click_on 'Salvar'

    expect(current_path).to eq event_path(event)
    expect(page).to have_content 'Datas editadas com sucesso.'
  end
end
