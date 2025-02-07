# E-Ventos

![Static Badge](https://img.shields.io/badge/Ruby_3.3.2-CC342D?style=for-the-badge&logo=ruby&logoColor=white)

## Descrição do Projeto

Este é um sistema completo de gerenciamento de eventos, permitindo que organizadores criem e gerenciem eventos de forma eficiente. O aplicativo suporta a criação de contas de organizadores, cadastro de eventos, configuração de ingressos e agendas, além da verificação de usuários. Administradores têm acesso a ferramentas para moderar usuários, gerenciar categorias de eventos e configurar palavras-chave para facilitar buscas. O sistema também controla limites de participantes e lotes de ingressos, com diferentes opções e preços.

## Funcionalidades

- Cadastro de organizadores
- Cadastro de administradores
- Cadastro de eventos
- Cadastro de Agenda de eventos
- Categorias de eventos com palavras-chave associadas
- Cadastro de Lotes
- Cadastro de Comunicados
- Cadastro de Locais de eventos
- Cadastro de Recomendações de eventos
- Verificação do usuário
- Feedback do evento
- Histórico de eventos

## Gems utilizadas

- CPF_CNPJ
- Cuprite
- Discard
- Factory Bot
- Rubocop
- Rspec
- Capybara
- Devise
- Faraday
- Timecop
- Discard

## Pré-requisitos

ruby 3.3.2
rails 8.0.1
node 16.20.2

## Como executar a aplicação

```bash
  # Clone o repositório
    $ git clone git@github.com:TreinaDev/events-app.git

  # Acesse a pasta do projeto
    $ cd events-app

  # Instale as dependências
    $ bundle install

  # Execute a aplicação
    $ bin/setup

  # A aplicação estará disponível em
    http://localhost:3003
```

## Como rodar testes

```bash
  # Execute os testes
    $ bundle exec rspec
```

## Navegação

- Usuário organizador de eventos:
  Login: joao@email.com
  Senha: password123
- Usuário administrador:
  Login: alice@meuevento.com.br
  Senha: password123

# APIs

Para ver os endpoint acesse esse link: [Documentação da API](doc/API_README.md).

## Contribuidores

| [<img src="https://avatars.githubusercontent.com/u/62516296?v=4" width=100> <br> <sub>Vinícius Fernandes</sub>](https://github.com/viniciusfer01) | [<img src="https://avatars.githubusercontent.com/u/133027507?v=4" width=100> <br> <sub>Gabriel Costa Toledo</sub>](https://github.com/gctoledo) | [<img src="https://avatars.githubusercontent.com/u/145959872?v=4" width=100> <br> <sub>Willian Deiviti Daniel</sub>](https://github.com/WillianDDaniel) | [<img src="https://avatars.githubusercontent.com/u/102266797?v=4" width=100> <br> <sub>Marcos Guimarães</sub>](https://github.com/marcos-grocha) | [<img src="https://avatars.githubusercontent.com/u/65390774?v=4" width=100> <br> <sub>Rodrigo Moreno</sub>](https://github.com/rmoreno-w) | [<img src="https://avatars.githubusercontent.com/u/140606120?v=4" width=100> <br> <sub>Fábio Mizo Guti</sub>](https://github.com/Fabio-k) |
| :-----------------------------------------------------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------------------------------------: |
