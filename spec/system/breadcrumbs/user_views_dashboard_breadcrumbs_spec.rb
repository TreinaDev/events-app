require 'rails_helper'

describe 'Usuário consegue ver as breadcrumbs' do
  it 'na página de dashboard(home)' do
    user = create(:user)
    login_as user

    visit dashboard_path

    expect(current_path).to eq dashboard_path
    within "#breadcrumbs" do
      expect(page).to have_content "Home"
    end
  end
end
