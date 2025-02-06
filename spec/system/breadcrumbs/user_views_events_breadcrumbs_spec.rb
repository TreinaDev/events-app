require 'rails_helper'

describe 'Usuário consegue ver as breadcrumbs' do
  it 'na página de criar evento' do
    user = create(:user)
    login_as user

    visit new_event_path

    expect(current_path).to eq new_event_path
    within "#breadcrumbs" do
      expect(page).to have_link "Home"
      expect(page).to have_content "Cadastro de Evento"
    end
  end

  it 'na página de detalhes de um evento' do
    user = create(:user)
    event = create(:event, user: user)
    login_as user

    visit event_path(event)

    expect(current_path).to eq event_path(event)
    within "#breadcrumbs" do
      expect(page).to have_link "Home"
      expect(page).to have_content "#{event.name}"
    end
  end

  it 'na página de editar um evento' do
    user = create(:user)
    event = create(:event, user: user)
    login_as user

    visit edit_event_path(event)

    expect(current_path).to eq edit_event_path(event)
    within "#breadcrumbs" do
      expect(page).to have_link "Home"
      expect(page).to have_link "#{event.name}"
      expect(page).to have_content "Editar Evento"
    end
  end

  it 'na página de histórico de eventos' do
    event_manager = create(:user)
    create(:event, user: event_manager)
    admin = create(:user, :admin)
    login_as admin

    visit history_events_path

    expect(current_path).to eq history_events_path
    within "#breadcrumbs" do
      expect(page).to have_link "Home"
      expect(page).to have_content "Histórico de eventos"
    end
  end
end
