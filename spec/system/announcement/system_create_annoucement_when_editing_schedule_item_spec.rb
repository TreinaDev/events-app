require 'rails_helper'

describe 'Sistema cria anuncio ao editar um item de agenda' do
  it 'com sucesso' do
    user = create(:user)
    event = create(:event, name: 'Introdução ao RoR', user: user)
    event.published!
    schedule = create(:schedule, event: event)
    schedule_item = create(:schedule_item, schedule: schedule, name: 'Atividade')

    schedule_item.update(name: 'Novo Nome')

    login_as user

    visit event_announcements_path(event)

    expect(page).to have_content 'Atualização na atividade Novo Nome'
    expect(page).to have_content "As seguintes alterações foram feitas: Nome alterado de 'Atividade' para 'Novo Nome'."
  end

  it 'não cria anuncio se nao houver alterações' do
    user = create(:user)
    event = create(:event, name: 'Introdução ao RoR', user: user)
    event.published!
    schedule = create(:schedule, event: event)
    create(:schedule_item, schedule: schedule, name: 'Curso Rails')

    login_as user

    visit event_announcements_path(event)

    expect(page).not_to have_content 'Atualização na atividade Curso Rails'
  end
end
