require 'rails_helper'

describe 'Visitante abre a app', type: :system do
  it 'com sucesso' do
    visit root_path
    expect(page).to have_content 'Olá mundo'
  end

  it 'com sucesso e JavaScript', js: true do
    visit root_path
    click_on 'Ver mensagem'
    expect(page).to have_content "Olá mundo via StimulusJS"
  end
end
