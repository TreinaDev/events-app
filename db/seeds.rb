# readme md -> rails db:drop -> rails db:migrate -> rails db:seed
puts 'Apagando todos os dados...'
Category.destroy_all
Event.destroy_all
User.destroy_all

puts 'Criando dois usuários...'
FactoryBot.create(:user, :admin)
user = FactoryBot.create(:user, name: 'Joao', family_name: 'Campus', registration_number: CPF.generate, email: 'joao@email.com', password: 'password123')

puts 'Criando três categorias...'
ruby_category = FactoryBot.create(:category, name: 'Ruby')
programacao_category = FactoryBot.create(:category, name: 'Programação')
javascript_category = FactoryBot.create(:category, name: 'JavaScript')

puts 'Criando dois eventos e amarrando as categorias...'
FactoryBot.create(:event, name: 'Conferencia Ruby', event_type: :online, address: 'Sem endereço', participants_limit: 20, url: 'confruby.com.br', status: :draft, user: user, categories: [ ruby_category, programacao_category ])
FactoryBot.create(:event, name: 'Conferencia JS', event_type: :inperson, address: 'Rua dos Computadores, 125', participants_limit: 30, url: 'confjs.com.br', status: :published, user: user, categories: [ javascript_category ])
event = FactoryBot.create(:event, name: 'Tropical on Rails 2025', event_type: :hybrid, address: 'Auditório Hotel Pullman - Vila Olímpia, São Paulo - SP', participants_limit: 30, url: 'www.evento.com', status: :published, user: user, categories: [ ruby_category ], description: "O Tropical on Rails 2025 é a Conferência Latam de Rails e tem como objetivo fortalecer a comunidade de Rails da América Latina para que ela continue sendo uma parte integral do presente e do futuro do Ruby on Rails. O que antes era bom como Tropical.rb agora ficou melhor ainda sendo Tropical On Rails, nossa estrutura também cresceu e nessa edição vamos ter 700 com palestrantes incríveis estarão no nosso palco: Xavier Noria, Chris Oliver, Rosa Gutiérrez, Irina Nazarova, Rafael França, Vinicius Stock e muitos outros.")
event.logo.attach(io: File.open(Rails.root.join('spec/support/images/logo.jpg')), filename: 'logo.jpg')
sleep(5)
event.banner.attach(io: File.open(Rails.root.join('spec/support/images/banner.png')), filename: 'banner.png')

puts 'Criando palavras-chave...'
backend_keyword = FactoryBot.create(:keyword, value: 'Backend')
frontend_keyword = FactoryBot.create(:keyword, value: 'Frontend')
FactoryBot.create(:keyword, value: 'Segurança')
CategoryKeyword.create(category: ruby_category, keyword: backend_keyword)
CategoryKeyword.create(category: javascript_category, keyword: frontend_keyword)

puts 'Seeds aplicados com sucesso!'
