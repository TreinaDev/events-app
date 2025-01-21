require 'rails_helper'

describe 'Usuário tenta criar uma palavra-chave' do
  it 'e consegue com sucesso' do
    user = create(:user, :admin)
    login_as user

    visit root_path
    click_on 'Categorias'
    click_on '+ Palavra-Chave'
    fill_in 'Palavra-Chave', with: 'Backend'
    click_on 'Cadastrar'

    expect(page).to have_content 'Palavra-Chave Backend cadastrada com sucesso!'
    expect(current_path).to eq categories_path
  end

  it 'mas falha por informar dados inválidos' do
    user = create(:user, :admin)
    login_as user

    visit new_keyword_path
    fill_in 'Palavra-Chave', with: ''
    click_on 'Cadastrar'

    expect(page).to have_content 'Erro ao cadastrar a Palavra-Chave.'
    expect(current_path).to eq new_keyword_path
  end
end
