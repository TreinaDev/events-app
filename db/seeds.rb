# readme md -> rails db:drop -> rails db:migrate -> rails db:seed
puts 'Apagando todos os dados...'
ScheduleItem.destroy_all
Schedule.destroy_all
TicketBatch.destroy_all
CategoryKeyword.destroy_all
Keyword.destroy_all
EventCategory.destroy_all
Event.destroy_all
Category.destroy_all
User.destroy_all

puts 'Criando DOIS usuários ADMINISTRADORES...'
FactoryBot.create(:user, :admin)
FactoryBot.create(:user, :admin, name: 'Kleber', family_name: 'Renan', registration_number: CPF.generate, email: 'kleber@meuevento.com.br', password: 'password123')

puts 'Criando DOIS usuários ORGANIZADORES...'
user = FactoryBot.create(:user, name: 'Joao', family_name: 'Campus', registration_number: CPF.generate, email: 'joao@email.com', password: 'password123')
FactoryBot.create(:user, name: 'Maria', family_name: 'Campus', registration_number: CPF.generate, email: 'maria@email.com', password: 'password123')

puts 'Criando CINCO categorias...'
ruby_category = FactoryBot.create(:category, name: 'Ruby')
programacao_category = FactoryBot.create(:category, name: 'Programação')
javascript_category = FactoryBot.create(:category, name: 'JavaScript')
FactoryBot.create(:category, name: 'Java')
FactoryBot.create(:category, name: 'C#')

puts 'Criando evento RUBY e amarrando as categorias...'
ruby_event = FactoryBot.create(:event, name: 'Conferencia Ruby', event_type: :online, address: 'Sem endereço', participants_limit: 25, url: 'confruby.com.br', status: :draft, user: user, categories: [ ruby_category, programacao_category ], start_date: 2.weeks.from_now, end_date: 3.weeks.from_now, description: 'Um evento maneiro de Ruby')
ruby_event.logo.attach(io: File.open(Rails.root.join('spec/support/images/ruby.png')), filename: 'ruby.png')
sleep(5)
ruby_event.banner.attach(io: File.open(Rails.root.join('spec/support/images/banner_ruby.png')), filename: 'banner_ruby.png')

puts 'Criando evento JAVASCRIPT e amarrando as categorias...'
javascript_event = FactoryBot.create(:event, name: 'Conferencia JS', event_type: :inperson, address: 'Rua dos Computadores, 125', participants_limit: 30, url: 'confjs.com.br', status: :published, user: user, categories: [ javascript_category ], start_date: 2.weeks.from_now, end_date: 3.weeks.from_now, description: 'Um evento maneiro de Java escrito')
javascript_event.logo.attach(io: File.open(Rails.root.join('spec/support/images/javascript.png')), filename: 'javascript.png')
sleep(5)
javascript_event.banner.attach(io: File.open(Rails.root.join('spec/support/images/banner_javascript.png')), filename: 'banner_javascript.png')

puts 'Criando evento TROPICAL e amarrando as categorias...'
tropical_event = FactoryBot.create(:event, name: 'Tropical on Rails 2025', event_type: :hybrid, address: 'Auditório Hotel Pullman - Vila Olímpia, São Paulo - SP', participants_limit: 30, url: 'www.evento.com', status: :published, user: user, categories: [ ruby_category ], start_date: 2.weeks.from_now, end_date: 3.weeks.from_now, description: "O Tropical on Rails 2025 é a Conferência Latam de Rails e tem como objetivo fortalecer a comunidade de Rails da América Latina para que ela continue sendo uma parte integral do presente e do futuro do Ruby on Rails. O que antes era bom como Tropical.rb agora ficou melhor ainda sendo Tropical On Rails, nossa estrutura também cresceu e nessa edição vamos ter 700 com palestrantes incríveis estarão no nosso palco: Xavier Noria, Chris Oliver, Rosa Gutiérrez, Irina Nazarova, Rafael França, Vinicius Stock e muitos outros.")
tropical_event.logo.attach(io: File.open(Rails.root.join('spec/support/images/logo.jpg')), filename: 'logo.jpg')
sleep(5)
tropical_event.banner.attach(io: File.open(Rails.root.join('spec/support/images/banner.png')), filename: 'banner.png')

puts 'Criando QUATRO palavras-chave e amarrando as categorias...'
FactoryBot.create(:keyword, value: 'Segurança')
FactoryBot.create(:keyword, value: 'Full-Stack')
backend_keyword = FactoryBot.create(:keyword, value: 'Backend')
frontend_keyword = FactoryBot.create(:keyword, value: 'Frontend')
CategoryKeyword.create(category: ruby_category, keyword: backend_keyword)
CategoryKeyword.create(category: javascript_category, keyword: frontend_keyword)

puts 'Criando PRIMEIRO LOTE de ingressos para CADA evento...'
FactoryBot.create(:ticket_batch, name: 'Primeiro Lote - Inteira', tickets_limit: 5, event: ruby_event, start_date: 1.weeks.from_now, end_date: 2.weeks.from_now, discount_option: :no_discount)
FactoryBot.create(:ticket_batch, name: 'Primeiro Lote - Inteira', tickets_limit: 10, event: javascript_event, start_date: 1.weeks.from_now, end_date: 2.weeks.from_now, discount_option: :no_discount)
FactoryBot.create(:ticket_batch, name: 'Primeiro Lote - Inteira', tickets_limit: 10, event: tropical_event, start_date: 1.weeks.from_now, end_date: 2.weeks.from_now, discount_option: :no_discount)

puts 'Criando SEGUNDO LOTE de ingressos para CADA evento...'
FactoryBot.create(:ticket_batch, name: 'Segundo Lote - Inteira', tickets_limit: 10, event: ruby_event, start_date: 8.days.from_now, end_date: 12.days.from_now, ticket_price: '129.99', discount_option: :no_discount)
FactoryBot.create(:ticket_batch, name: 'Segundo Lote - Inteira', tickets_limit: 10, event: javascript_event, start_date: 8.days.from_now, end_date: 12.days.from_now, ticket_price: '129.99', discount_option: :no_discount)
FactoryBot.create(:ticket_batch, name: 'Segundo Lote - Inteira', tickets_limit: 10, event: tropical_event, start_date: 8.days.from_now, end_date: 12.days.from_now, ticket_price: '129.99', discount_option: :no_discount)

puts 'Criando SEGUNDO LOTE - MEIA ingressos para CADA evento...'
FactoryBot.create(:ticket_batch, name: 'Segundo Lote - Meia Estudante', tickets_limit: 5, event: ruby_event, start_date: 8.days.from_now, end_date: 12.days.from_now, ticket_price: '129.99', discount_option: :student)
FactoryBot.create(:ticket_batch, name: 'Segundo Lote - Meia Estudante', tickets_limit: 5, event: javascript_event, start_date: 8.days.from_now, end_date: 12.days.from_now, ticket_price: '129.99', discount_option: :student)
FactoryBot.create(:ticket_batch, name: 'Segundo Lote - Meia Estudante', tickets_limit: 5, event: tropical_event, start_date: 8.days.from_now, end_date: 12.days.from_now, ticket_price: '129.99', discount_option: :student)

puts 'Criando DOIS itens de agenda PARA TROPICAL ON RAILS...'
FactoryBot.create(:schedule_item, schedule: tropical_event.schedules.first, name: 'Paletra sobre Rails 8', description: 'Discutindo sobre as novidades que chegaram para o Rails na sua versão 8.')
FactoryBot.create(:schedule_item, schedule: tropical_event.schedules.first, name: 'Palestra sobre futuro do Rails', description: 'Discutindo sobre as novidades que chegarão para o Rails.', start_time: (Time.now).change(hour: 10, min: 0, sec: 0), end_time: (Time.now).change(hour: 11, min: 0, sec: 0), responsible_name: 'Marcos', responsible_email: 'marcos@email.com')

puts 'Criando DOIS itens de agenda PARA CONFERENCIA DE JS...'
FactoryBot.create(:schedule_item, schedule: javascript_event.schedules.first, name: 'Paletra sobre NodeJS', description: 'Palestra sobre tudo de NodeJS.')
FactoryBot.create(:schedule_item, schedule: javascript_event.schedules.first, name: 'Palestra sobre Bun', description: 'Palestra sobre tudo do Bun', start_time: (Time.now).change(hour: 10, min: 0, sec: 0), end_time: (Time.now).change(hour: 11, min: 0, sec: 0), responsible_name: 'Marcos', responsible_email: 'marcos@email.com')

puts 'Criando DOIS itens de agenda PARA CONFERENCIA RUBY...'
FactoryBot.create(:schedule_item, schedule: ruby_event.schedules.first, name: 'Paletra sobre Ruby', description: 'Discutindo sobre a linguagem Ruby.')
FactoryBot.create(:schedule_item, schedule: ruby_event.schedules.first, name: 'Palestra sobre as vantagens do Ruby', description: 'Discutindo e comparando Ruby com outras linguagens de programação.', start_time: (Time.now).change(hour: 10, min: 0, sec: 0), end_time: (Time.now).change(hour: 11, min: 0, sec: 0), responsible_name: 'Marcos', responsible_email: 'marcos@email.com')

puts 'Seeds aplicados com sucesso!'
