require 'rails_helper'

describe 'Usuário deleta um item de agenda' do
  it 'com sucesso' do
    user = create(:user)
    category = create(:category, name: 'Tecnologia')
    event = create(:event, name: 'Introdução ao RoR', user: user, categories: [ category ])
    schedule = create(:schedule, event: event)
    schedule_item = create(:schedule_item, schedule: schedule)

    login_as user
    visit events_path
    find("a[test_id='manage-#{event.id}']").click
    click_on schedule.date.strftime("%d/%m")
    find("button[data-test-id='delete-#{schedule_item.id}']").click

    expect(page).to have_content 'Item deletado com sucesso'
  end
end
