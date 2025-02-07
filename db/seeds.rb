puts 'Criando DOIS usuários do tipo ADMINISTRADOR...'
FactoryBot.create(:user, :admin)
FactoryBot.create(:user, :admin, name: 'Kleber', family_name: 'Renan', registration_number: CPF.generate, email: 'kleber@meuevento.com.br', password: 'password123')

puts 'Criando DOIS usuários do tipo ORGANIZADOR...'
joao_user = FactoryBot.create(:user, name: 'Joao', family_name: 'Campus', registration_number: CPF.generate, email: 'joao@email.com', password: 'password123')
maria_user = FactoryBot.create(:user, :with_pending_request, name: 'Maria', family_name: 'Campus', registration_number: CPF.generate, email: 'maria@email.com', password: 'password123')

puts 'Criando CINCO categorias...'
ruby_category = FactoryBot.create(:category, name: 'Ruby')
programacao_category = FactoryBot.create(:category, name: 'Programação')
javascript_category = FactoryBot.create(:category, name: 'JavaScript')
cloud_category = FactoryBot.create(:category, name: 'Nuvem')
FactoryBot.create(:category, name: 'Java')
FactoryBot.create(:category, name: 'C#')

puts 'Criando CINCO palavras-chave...'
FactoryBot.create(:keyword, value: 'Banco de Dados')
FactoryBot.create(:keyword, value: 'Segurança')
FactoryBot.create(:keyword, value: 'Full-Stack')
backend_keyword = FactoryBot.create(:keyword, value: 'Backend')
frontend_keyword = FactoryBot.create(:keyword, value: 'Frontend')

puts 'Amarrando CATEGORIAS e PALAVRAS-CHAVE...'
CategoryKeyword.create(category: ruby_category, keyword: backend_keyword)
CategoryKeyword.create(category: javascript_category, keyword: frontend_keyword)

puts 'Criando evento CONFERENCIA RUBY...'
ruby_event = FactoryBot.create(:event,
  name: 'Conferencia Ruby',
  event_type: :online,
  address: 'Sem endereço',
  participants_limit: 25,
  url: 'confruby.com.br',
  status: :draft,
  user: joao_user,
  categories: [ ruby_category, programacao_category ],
  start_date: 2.weeks.from_now,
  end_date: 3.weeks.from_now,
  description: 'Um evento maneiro de Ruby'
)
ruby_event.logo.attach(io: File.open(Rails.root.join('spec/support/images/ruby.png')), filename: 'ruby.png')
sleep(5)
ruby_event.banner.attach(io: File.open(Rails.root.join('spec/support/images/banner_ruby.png')), filename: 'banner_ruby.png')

puts 'Criando evento CONFERENCIA JAVASCRIPT...'
javascript_event = FactoryBot.create(:event,
  name: 'Conferencia JS',
  event_type: :inperson,
  address: 'Rua dos Computadores, 125',
  participants_limit: 30,
  url: 'confjs.com.br',
  status: :published,
  user: joao_user,
  categories: [ javascript_category ],
  start_date: 2.weeks.from_now,
  end_date: 3.weeks.from_now,
  description: 'Um evento maneiro de Java escrito'
)
javascript_event.logo.attach(io: File.open(Rails.root.join('spec/support/images/javascript.png')), filename: 'javascript.png')
sleep(5)
javascript_event.banner.attach(io: File.open(Rails.root.join('spec/support/images/banner_javascript.png')), filename: 'banner_javascript.png')

puts 'Criando evento AWS'
aws_event = FactoryBot.create(:event,
  name: 'AWS re:Invent',
  event_type: :online,
  participants_limit: 20,
  url: 'reinvent.awsevents.com',
  status: :published,
  user: joao_user,
  categories: [ cloud_category ],
  start_date: 2.minute.from_now,
  end_date: 4.minutes.from_now,
  description: ActionText::Content.new("<h1>Uma semana incrível para aprender fazendo</h1>De palestras interessantes a sessões e conexões de mudança de carreira, o re:Invent 2024 foi um sucesso incrível – e mal podemos esperar para fazê-lo novamente. As inscrições para o re:Invent 2025 abrem neste verão. <div><br><br><img src='https://reinvent.awsevents.com/content/dam/reinvent/2024/media/cards/topics/gen-ai/image-3.png' alt='decoration'></div>")
)
aws_event.logo.attach(io: File.open(Rails.root.join('spec/support/images/logo_aws.png')), filename: 'logo_aws.png')
sleep(5)
aws_event.banner.attach(io: File.open(Rails.root.join('spec/support/images/banner_aws.jpg')), filename: 'banner_aws.jpg')
aws_event.update_columns(start_date: 4.days.ago, end_date: 1.day.ago, code: 'ABCD1234')
aws_event.schedules.first.update_columns(date: 4.days.ago)
(1..3).each do |d|
  schedule = aws_event.schedules.create(date: 1.day.from_now)
  schedule.update_columns(date: d.days.ago)
end


puts 'Criando evento TROPICAL ON RAILS...'
tropical_event = FactoryBot.create(:event,
  name: 'Tropical on Rails 2025',
  event_type: :hybrid,
  address: 'Auditório Hotel Pullman - Vila Olímpia, São Paulo - SP',
  participants_limit: 30,
  url: 'www.evento.com',
  status: :published,
  user: joao_user,
  categories: [ ruby_category ],
  start_date: Time.now,
  end_date: 1.day.from_now,
  description: ActionText::Content.new('<div><p><strong>O Tropical on Rails 2025</strong> é a <strong>Conferência Latam de Rails</strong> e tem como objetivo fortalecer a comunidade de Rails da América Latina para que ela continue sendo uma parte integral do presente e do futuro do Ruby on Rails.</p><br><p>O que antes era bom como <strong>Tropical.rb</strong> agora ficou melhor ainda sendo <strong>Tropical On Rails</strong>, nossa estrutura também cresceu e nessa edição vamos ter <strong>700 participantes</strong> com palestrantes incríveis estarão no nosso palco:</p><br><p><strong>Xavier Noria, Chris Oliver, Rosa Gutiérrez, Irina Nazarova, Rafael França, Vinicius Stock</strong> e muitos outros.</p></div><br><br><div><img src="https://framerusercontent.com/images/qYmo4AWLxXHNG2rARTdN8a1Vovw.jpeg" alt="plateia"></div>')
)
tropical_event.logo.attach(io: File.open(Rails.root.join('spec/support/images/logo.jpg')), filename: 'logo.jpg')
sleep(5)
tropical_event.banner.attach(io: File.open(Rails.root.join('spec/support/images/banner.png')), filename: 'banner.png')
tropical_event.update_columns(code: 'EFGH1234')

puts 'Criando evento RUBY SUMMIT BRASIL 2025...'
ruby_summit_event = FactoryBot.create(:event,
  name: 'Ruby Summit Brasil 2025',
  event_type: :inperson,
  address: 'Teatro Renaissance - São Paulo, SP',
  participants_limit: 30,
  url: 'www.rubysummitbr.com',
  user: maria_user,
  categories: [ ruby_category ],
  start_date: 1.month.from_now,
  end_date: (1.month.from_now + 1.day),
  description: "O Ruby Summit Brasil 2025 reúne a comunidade Ruby brasileira em um evento repleto de palestras, painéis e workshops com os melhores especialistas do mercado. Com keynotes internacionais e espaço para networking, é a oportunidade ideal para aprender e compartilhar conhecimento sobre Ruby e suas tecnologias relacionadas.",
  banner: nil
)
ruby_summit_event.logo.attach(io: File.open(Rails.root.join('spec/support/images/ruby-summit-brasil.png')), filename: 'ruby-summit-brasil.png')
sleep(5)

puts 'Criando evento FULL STACK CONF 2025...'
full_stack_conf_event = FactoryBot.create(:event,
  name: 'Full Stack Conf 2025',
  event_type: :online,
  address: nil,
  participants_limit: 30,
  url: 'www.fullstackconf.com',
  user: maria_user,
  categories: [ ruby_category, javascript_category ],
  start_date: 3.months.from_now,
  end_date: (3.months.from_now + 2.days),
  description: "A Full Stack Conf 2025 é o evento definitivo para desenvolvedores full stack, abordando as principais tendências e tecnologias do mercado. Com palestras sobre Ruby, JavaScript, DevOps, arquitetura de software e mais, reunimos especialistas e profissionais de todo o mundo para compartilhar insights e experiências.",
  logo: nil
)
full_stack_conf_event.banner.attach(io: File.open(Rails.root.join('spec/support/images/banner_fullstackconf.png')), filename: 'banner_fullstackconf.png')

puts 'Criando PRIMEIRO LOTE de ingressos para CADA evento...'
FactoryBot.create(:ticket_batch, name: 'Primeiro Lote - Inteira', tickets_limit: 10, event: javascript_event, start_date:  1.day.ago, end_date: 2.weeks.from_now, discount_option: :no_discount)
FactoryBot.create(:ticket_batch, name: 'Primeiro Lote - Inteira', tickets_limit: 10, event: tropical_event, start_date: 1.week.ago, end_date: 3.minutes.from_now, discount_option: :no_discount)
FactoryBot.create(:ticket_batch, name: 'Primeiro Lote - Inteira', tickets_limit: 10, event: ruby_summit_event, start_date:  1.day.ago, end_date: 2.weeks.from_now, discount_option: :no_discount)
FactoryBot.create(:ticket_batch, name: 'Primeiro Lote - Inteira', tickets_limit: 10, event: full_stack_conf_event, start_date:  1.day.ago, end_date: 2.weeks.from_now, discount_option: :no_discount)
aws_event_batch = FactoryBot.create(:ticket_batch, name: 'Primeiro Lote - Inteira', tickets_limit: 10, event: aws_event, start_date: 2.week.ago, end_date: 1.week.ago, discount_option: :no_discount)
aws_event_batch.update_columns(code: 'ABCD1234')
tropical_event_batch = FactoryBot.create(:ticket_batch, name: 'Primeiro Lote - Inteira', tickets_limit: 10, event: tropical_event, start_date: 1.week.ago, end_date: 1.day.ago, discount_option: :no_discount)
tropical_event_batch.update_columns(code: 'EFGH1234')

puts 'Criando PRIMEIRO LOTE - MEIA (PCD) de ingressos para CADA evento...'
FactoryBot.create(:ticket_batch, name: 'Primeiro Lote - Meia PCD', tickets_limit: 5, event: ruby_event, start_date: 1.weeks.from_now, end_date: 2.weeks.from_now, discount_option: :disability)
FactoryBot.create(:ticket_batch, name: 'Primeiro Lote - Meia PCD', tickets_limit: 5, event: javascript_event, start_date: 1.weeks.from_now, end_date: 2.weeks.from_now, discount_option: :disability)
FactoryBot.create(:ticket_batch, name: 'Primeiro Lote - Meia PCD', tickets_limit: 5, event: tropical_event, start_date: 1.week.ago, end_date: 3.minutes.from_now, discount_option: :disability)
FactoryBot.create(:ticket_batch, name: 'Primeiro Lote - Meia PCD', tickets_limit: 5, event: ruby_summit_event, start_date: 1.weeks.from_now, end_date: 2.weeks.from_now, discount_option: :disability)
FactoryBot.create(:ticket_batch, name: 'Primeiro Lote - Meia PCD', tickets_limit: 5, event: full_stack_conf_event, start_date: 4.weeks.ago, end_date: 3.weeks.ago, discount_option: :disability)

puts 'Criando SEGUNDO LOTE de ingressos para CADA evento...'
FactoryBot.create(:ticket_batch, name: 'Segundo Lote - Inteira', tickets_limit: 5, event: ruby_event, start_date: 8.days.from_now, end_date: 12.days.from_now, ticket_price: '129.99', discount_option: :no_discount)
FactoryBot.create(:ticket_batch, name: 'Segundo Lote - Inteira', tickets_limit: 10, event: javascript_event, start_date: 8.days.from_now, end_date: 12.days.from_now, ticket_price: '129.99', discount_option: :no_discount)
FactoryBot.create(:ticket_batch, name: 'Segundo Lote - Inteira', tickets_limit: 10, event: tropical_event, start_date: 8.weeks.ago, end_date: 3.minutes.from_now, ticket_price: '129.99', discount_option: :no_discount)
FactoryBot.create(:ticket_batch, name: 'Segundo Lote - Inteira', tickets_limit: 10, event: ruby_summit_event, start_date: 8.days.from_now, end_date: 12.days.from_now, ticket_price: '129.99', discount_option: :no_discount)
FactoryBot.create(:ticket_batch, name: 'Segundo Lote - Inteira', tickets_limit: 10, event: full_stack_conf_event, start_date: 4.weeks.ago, end_date: 3.weeks.ago, ticket_price: '129.99', discount_option: :no_discount)

puts 'Criando SEGUNDO LOTE - MEIA (Estudante) de ingressos para CADA evento...'
FactoryBot.create(:ticket_batch, name: 'Segundo Lote - Meia Estudante', tickets_limit: 5, event: ruby_event, start_date: 8.days.from_now, end_date: 12.days.from_now, ticket_price: '129.99', discount_option: :student)
FactoryBot.create(:ticket_batch, name: 'Segundo Lote - Meia Estudante', tickets_limit: 5, event: javascript_event, start_date: 8.days.from_now, end_date: 12.days.from_now, ticket_price: '129.99', discount_option: :student)
FactoryBot.create(:ticket_batch, name: 'Segundo Lote - Meia Estudante', tickets_limit: 5, event: tropical_event, start_date: 1.week.ago, end_date: 1.day.ago, ticket_price: '129.99', discount_option: :student)
FactoryBot.create(:ticket_batch, name: 'Segundo Lote - Meia Estudante', tickets_limit: 5, event: ruby_summit_event, start_date: 8.days.from_now, end_date: 12.days.from_now, ticket_price: '129.99', discount_option: :student)
FactoryBot.create(:ticket_batch, name: 'Segundo Lote - Meia Estudante', tickets_limit: 5, event: full_stack_conf_event, start_date: 4.weeks.ago, end_date: 3.weeks.ago, ticket_price: '129.99', discount_option: :student)

puts 'Criando PRIMEIRO item de agenda para CADA evento...'
FactoryBot.create(:schedule_item, schedule: ruby_event.schedules.first, name: 'Paletra sobre Ruby', description: 'Discutindo sobre a linguagem Ruby.')
FactoryBot.create(:schedule_item, schedule: javascript_event.schedules.first, name: 'Paletra sobre NodeJS', description: 'Palestra sobre tudo de NodeJS.')
FactoryBot.create(:schedule_item, schedule: tropical_event.schedules.first, name: 'Paletra sobre Rails 8', description: 'Discutindo sobre as novidades que chegaram para o Rails na sua versão 8.')
FactoryBot.create(:schedule_item, schedule: ruby_summit_event.schedules.first, name: 'Paletra sobre Rails', description: 'Discutindo sobre as noticias atuais do ruby no rails')
FactoryBot.create(:schedule_item, schedule: full_stack_conf_event.schedules.first, name: 'Paletra sobre FullStack', description: 'Palestra do backend ao frontend')
FactoryBot.create(:schedule_item, schedule: aws_event.schedules.order(date: :asc).first, name: 'Keynote de Abertura', description: 'Abertura oficial do evento com as últimas inovações e tendências em computação em nuvem.', start_time: (Time.now).change(hour: 9, min: 0, sec: 0), end_time: (Time.now).change(hour: 9, min: 45, sec: 0), responsible_name: 'Adam Selipsky', responsible_email: 'adam@email.com')

puts 'Criando SEGUNDO item de agenda para CADA evento...'
FactoryBot.create(:schedule_item, schedule: ruby_event.schedules.first, name: 'Palestra sobre as vantagens do Ruby', description: 'Discutindo e comparando Ruby com outras linguagens de programação.', start_time: (Time.now).change(hour: 10, min: 0, sec: 0), end_time: (Time.now).change(hour: 11, min: 0, sec: 0), responsible_name: 'Marcos', responsible_email: 'marcos@email.com')
FactoryBot.create(:schedule_item, schedule: javascript_event.schedules.first, name: 'Palestra sobre Bun', description: 'Palestra sobre tudo do Bun', start_time: (Time.now).change(hour: 10, min: 0, sec: 0), end_time: (Time.now).change(hour: 11, min: 0, sec: 0), responsible_name: 'Marcos', responsible_email: 'marcos@email.com')
FactoryBot.create(:schedule_item, schedule: tropical_event.schedules.first, name: 'Palestra sobre futuro do Rails', description: 'Discutindo sobre as novidades que chegarão para o Rails.', start_time: (Time.now).change(hour: 10, min: 0, sec: 0), end_time: (Time.now).change(hour: 11, min: 0, sec: 0), responsible_name: 'Marcos', responsible_email: 'marcos@email.com')
FactoryBot.create(:schedule_item, schedule: aws_event.schedules.order(date: :asc).first, name: 'Workshop - Arquitetura Serverless na AWS', description: 'Aprenda a construir aplicações escaláveis e eficientes utilizando AWS Lambda e outros serviços serverless.', start_time: (Time.now).change(hour: 11, min: 0, sec: 0), end_time: (Time.now).change(hour: 12, min: 30, sec: 0), responsible_name: 'Jeff Barr', responsible_email: 'jeff@email.com')

puts 'Criando item de agenda para outros dias do evento'
FactoryBot.create(:schedule_item, schedule: tropical_event.schedules.last, name: 'Como tornal um projeto Open Source um negócio', description: 'Como desenvolvedores, a codificação é a nossa zona de conforto, mas transformá-la em um negócio é outro desafio. Compartilharei minha jornada de um projeto paralelo para um negócio em tempo integral, incluindo as dificuldades, armadilhas comuns e "códigos de trapaça" úteis.', start_time: (Time.now).change(hour: 11, min: 0, sec: 0), end_time: (Time.now).change(hour: 11, min: 30, sec: 0), responsible_name: 'Adrian Marlin', responsible_email: 'adrian@email.com')
FactoryBot.create(:schedule_item, schedule: tropical_event.schedules.last, name: 'Como Começar a Criar Aplicativos Móveis Usando Rails e Turbo Native', description: 'Descubra Turbo, Turbo Native e Strada nesta palestra, onde mergulharemos em conceitos essenciais como webviews e técnicas para implantação de aplicações Rails em iOS e Android. Conheça as vantagens e desafios deste método inovador, abrindo novos horizontes para desenvolvedores Rails.', start_time: (Time.now).change(hour: 11, min: 40, sec: 0), end_time: (Time.now).change(hour: 12, min: 10, sec: 0), responsible_name: 'José Anchieta', responsible_email: 'jose@email.com')
FactoryBot.create(:schedule_item, schedule: tropical_event.schedules.last, schedule_type: :interval, name: 'Almoço', start_time: (Time.now).change(hour: 12, min: 15, sec: 0), end_time: (Time.now).change(hour: 14, min: 00, sec: 0))
FactoryBot.create(:schedule_item, schedule: tropical_event.schedules.last, name: 'Panel - Rails Foundation AMA', description: 'Robby Russell, CEO da Planet Argon, fará perguntas enviadas pela comunidade aos representantes da Rails Foundation.', start_time: (Time.now).change(hour: 14, min: 01, sec: 0), end_time: (Time.now).change(hour: 14, min: 45, sec: 0), responsible_name: 'Robby Russell', responsible_email: 'robby@email.com')
FactoryBot.create(:schedule_item, schedule: aws_event.schedules.order(date: :asc).first, name: 'Painel - Segurança na Nuvem', description: 'Discussão sobre práticas recomendadas para proteger workloads na AWS.', start_time: (Time.now).change(hour: 15, min: 0, sec: 0), end_time: (Time.now).change(hour: 15, min: 45, sec: 0), responsible_name: 'Merritt Baer', responsible_email: 'merritt@email.com')
FactoryBot.create(:schedule_item, schedule: aws_event.schedules.order(date: :asc).first, name: 'Networking e Happy Hour', description: 'Conecte-se com especialistas e participantes para trocar experiências sobre o mundo da nuvem.', start_time: (Time.now).change(hour: 18, min: 0, sec: 0), end_time: (Time.now).change(hour: 20, min: 0, sec: 0), responsible_name: 'Equipe AWS', responsible_email: 'contact@email.com')
FactoryBot.create(:schedule_item, schedule: aws_event.schedules.order(date: :asc).second, name: 'Deep Dive - Inteligência Artificial na AWS', description: 'Exploração avançada dos serviços de IA/ML na AWS, incluindo Amazon SageMaker.', start_time: (Time.now).change(hour: 9, min: 30, sec: 0), end_time: (Time.now).change(hour: 10, min: 30, sec: 0), responsible_name: 'Swami Sivasubramanian', responsible_email: 'swami@email.com')
FactoryBot.create(:schedule_item, schedule: aws_event.schedules.order(date: :asc).second, name: 'Workshop - Kubernetes no AWS EKS', description: 'Implementação e gerenciamento eficiente de clusters Kubernetes com Amazon EKS.', start_time: (Time.now).change(hour: 11, min: 15, sec: 0), end_time: (Time.now).change(hour: 12, min: 45, sec: 0), responsible_name: 'Abby Fuller', responsible_email: 'abby@email.com')
FactoryBot.create(:schedule_item, schedule: aws_event.schedules.order(date: :asc).second, name: 'Painel - FinOps na AWS', description: 'Melhores práticas para otimização de custos na nuvem sem comprometer a performance.', start_time: (Time.now).change(hour: 14, min: 0, sec: 0), end_time: (Time.now).change(hour: 14, min: 45, sec: 0), responsible_name: 'J.R. Storment', responsible_email: 'jr@email.com')
FactoryBot.create(:schedule_item, schedule: aws_event.schedules.order(date: :asc).second, name: 'AWS re:Play - Festa oficial', description: 'Uma noite de entretenimento e networking para encerrar o segundo dia do evento.', start_time: (Time.now).change(hour: 19, min: 0, sec: 0), end_time: (Time.now).change(hour: 23, min: 0, sec: 0), responsible_name: 'Equipe AWS', responsible_email: 'contact@email.com')
FactoryBot.create(:schedule_item, schedule: aws_event.schedules.order(date: :asc).third, name: 'Keynote - Futuro da Computação em Nuvem', description: 'Uma visão das inovações que estão moldando o futuro da AWS e da nuvem.', start_time: (Time.now).change(hour: 9, min: 0, sec: 0), end_time: (Time.now).change(hour: 9, min: 45, sec: 0), responsible_name: 'Peter DeSantis', responsible_email: 'peter@email.com')
FactoryBot.create(:schedule_item, schedule: aws_event.schedules.order(date: :asc).third, name: 'Workshop - Data Lakes e Analytics na AWS', description: 'Aprenda a construir um data lake escalável utilizando AWS Glue, Athena e Redshift.', start_time: (Time.now).change(hour: 11, min: 0, sec: 0), end_time: (Time.now).change(hour: 12, min: 30, sec: 0), responsible_name: 'Danilo Poccia', responsible_email: 'danilo@email.com')
FactoryBot.create(:schedule_item, schedule: aws_event.schedules.order(date: :asc).third, name: 'Painel - ESG e Sustentabilidade na Nuvem', description: 'Como a AWS está ajudando empresas a serem mais sustentáveis com soluções cloud.', start_time: (Time.now).change(hour: 14, min: 30, sec: 0), end_time: (Time.now).change(hour: 15, min: 15, sec: 0), responsible_name: 'Connie Hensler', responsible_email: 'connie@email.com')
FactoryBot.create(:schedule_item, schedule: aws_event.schedules.order(date: :asc).third, name: 'AWS GameDay - Desafio ao vivo', description: 'Participe de um desafio prático e demonstre suas habilidades resolvendo problemas reais na AWS.', start_time: (Time.now).change(hour: 17, min: 0, sec: 0), end_time: (Time.now).change(hour: 19, min: 0, sec: 0), responsible_name: 'Equipe AWS', responsible_email: 'gameday@email.com')
FactoryBot.create(:schedule_item, schedule: aws_event.schedules.order(date: :asc).fourth, name: 'Keynote de Encerramento', description: 'Reflexão sobre os aprendizados do evento e próximos passos na jornada AWS.', start_time: (Time.now).change(hour: 9, min: 0, sec: 0), end_time: (Time.now).change(hour: 9, min: 45, sec: 0), responsible_name: 'Werner Vogels', responsible_email: 'werner@email.com')
FactoryBot.create(:schedule_item, schedule: aws_event.schedules.order(date: :asc).fourth, name: 'Workshop - Automação e DevOps com AWS', description: 'Explore práticas avançadas de automação usando AWS CDK, CloudFormation e Terraform.', start_time: (Time.now).change(hour: 11, min: 0, sec: 0), end_time: (Time.now).change(hour: 12, min: 30, sec: 0), responsible_name: 'Kurt Kufeld', responsible_email: 'kurt@email.com')
FactoryBot.create(:schedule_item, schedule: aws_event.schedules.order(date: :asc).fourth, name: 'Painel - Casos de Sucesso na AWS', description: 'Empresas compartilham suas histórias de inovação e transformação digital na AWS.', start_time: (Time.now).change(hour: 14, min: 0, sec: 0), end_time: (Time.now).change(hour: 14, min: 45, sec: 0), responsible_name: 'Clientes AWS', responsible_email: 'sucessos@email.com')
FactoryBot.create(:schedule_item, schedule: aws_event.schedules.order(date: :asc).fourth, name: 'Encerramento e Despedida', description: 'Última oportunidade para networking e fechamento oficial do evento.', start_time: (Time.now).change(hour: 16, min: 30, sec: 0), end_time: (Time.now).change(hour: 17, min: 30, sec: 0), responsible_name: 'Equipe AWS', responsible_email: 'contact@email.com')
puts 'Adicionando Comunicados...'
FactoryBot.create(:announcement, user: joao_user, event: tropical_event, title: '📢 Comunicado Importante Tropical Rails 🌴🚂', description: '<div>Prezados participantes,</div><div>Agradecemos por fazerem parte da <strong>Tropical Rails</strong>! 🎉 Esperamos que estejam aproveitando as palestras, workshops e as incríveis conexões que este evento proporciona.</div><div>📌 <strong>Avisos Importantes:</strong><br>✅ <strong>Próxima palestra:</strong> hotwire em ação com João – 📍 Salão de palestras ⏰ 12:30<br>✅ <strong>Área de networking</strong> disponível na sala 3 para quem deseja trocar experiências com outros profissionais do setor.<br>✅ <strong>Lembre-se de usar a hashtag #TropicalRails para compartilhar sua experiência nas redes sociais!</strong></div><div>⚠️ <strong>Problemas ou dúvidas?</strong> Nossa equipe de apoio está disponível no balcão de informações e pelo WhatsApp: [inserir contato].</div><div>Aproveitem ao máximo e bons trilhos rumo à inovação! 🚆💡</div><div>Atenciosamente,<br><strong>Equipe Tropical Rails</strong></div>')
sleep(1)
FactoryBot.create(:announcement, user: joao_user, event: tropical_event, title: '📢 Pegue seu adesivo exclusivo da Tropical Rails! 🌴🚂', description: ActionText::Content.new('<div>Prezados participantes,</div><div>Para marcar sua presença na <strong>Tropical Rails</strong>, estamos distribuindo <strong>adesivos exclusivos do evento</strong>! 🎉</div><div><img src="	https://cdn.awsli.com.br/600x450/2772/2772081/produto/307088910/sticker-tzfqqiuiqp.jpg" alt="stickers"></div><div><br>🎟️ <strong>Quem pode retirar?</strong> Todos os participantes credenciados</div><div>Cole no seu notebook, garrafa, caderno ou onde quiser e mostre que você faz parte dessa experiência incrível!</div><div>⚠️ <strong>Os adesivos são limitados</strong>, então garanta o seu o quanto antes!</div><div>Nos vemos pelos trilhos da inovação! 🚆✨</div><div>Atenciosamente,<br><strong>Equipe Tropical Rails</strong></div>'))
FactoryBot.create(:announcement, user: joao_user, event: aws_event, title: 'AWS Summit 2024', description: ActionText::Content.new('<div><p><div><p>Estamos empolgados em anunciar o AWS Summit 2024! Este evento imperdível reunirá especialistas da indústria, líderes de pensamento e profissionais de TI para explorar as últimas inovações em computação em nuvem.</p><h2>O que você pode esperar?</h2><ul><li>🔹 Sessões técnicas aprofundadas sobre os serviços da AWS</li><li>🔹 Demonstrações ao vivo e laboratórios práticos</li><li>🔹 Palestras inspiradoras de líderes da indústria</li><li>🔹 Oportunidades de networking com profissionais de TI de todo o mundo</li></ul><p>Não perca a oportunidade de expandir seus conhecimentos e se conectar com a comunidade AWS.</p><h2>🔹 Inscreva-se agora e garanta sua vaga! 🔹</h2><img src="https://reinvent.awsevents.com/content/dam/reinvent/2024/media/cards/post-more-aws-events.png" alt="Pizza artesanal"></div>'))

puts 'Seeds aplicados com sucesso!'
