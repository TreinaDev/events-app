require 'rails_helper'

RSpec.describe Event, type: :model do
  describe '#valid' do
    it 'falso quando nome não está preenchido' do
      event = FactoryBot.build(:event, name: '')
      event.valid?

      expect(event.errors[:name]).to include 'não pode ficar em branco'
      expect(event).not_to be_valid
    end

    it 'falso quando endereço não está preenchido' do
      event = FactoryBot.build(:event, address: '')
      event.valid?

      expect(event.errors[:address]).to include 'não pode ficar em branco'
      expect(event).not_to be_valid
    end

    it 'falso quando limite de participantes não está preenchido' do
      event = FactoryBot.build(:event, participants_limit: '')
      event.valid?

      expect(event.errors[:participants_limit]).to include 'não pode ficar em branco'
      expect(event).not_to be_valid
    end

    it 'falso quando url do evento não está preenchido' do
      event = FactoryBot.build(:event, url: '')
      event.valid?

      expect(event.errors[:url]).to include 'não pode ficar em branco'
      expect(event).not_to be_valid
    end

    it 'falso quando a logo possui um formato inválido' do
      event = FactoryBot.build(:event)
      event.logo.attach(io: File.open('spec/support/test_file.txt'), filename: 'test_file.txt', content_type: 'text/plain')
      event.valid?

      expect(event.errors[:logo]).to include 'deve ser uma imagem do tipo PNG, JPG ou JPEG'
      expect(event).not_to be_valid
    end

    it 'falso quando banner possui um formato inválido' do
      event = FactoryBot.build(:event)
      event.banner.attach(io: File.open('spec/support/test_file.txt'), filename: 'test_file.txt', content_type: 'text/plain')
      event.valid?

      expect(event.errors[:banner]).to include 'deve ser uma imagem do tipo PNG, JPG ou JPEG'
      expect(event).not_to be_valid
    end

    it 'falso quando não possui ao menos 1 categoria' do
      event = FactoryBot.build(:event, categories: [])
      event.valid?

      expect(event.errors).to include(:categories)
      expect(event).not_to be_valid
    end

    it 'falso quando a data de início não está presente' do
      event = FactoryBot.build(:event, start_date: '')
      event.valid?

      expect(event).not_to be_valid
      expect(event.errors).to include(:start_date)
    end

    it 'falso quando a data de fim não está presente' do
      event = FactoryBot.build(:event, end_date: '')
      event.valid?

      expect(event).not_to be_valid
      expect(event.errors).to include(:end_date)
    end

    it 'falso quando a data de início do evento é anterior à data atual' do
      event = FactoryBot.build(:event, start_date: 2.days.ago)
      event.valid?

      expect(event).not_to be_valid
      expect(event.errors).to include(:start_date)
    end

    it 'falso quando a data de fim do evento é anterior à data atual' do
      event = FactoryBot.build(:event, end_date: 1.days.ago)
      event.valid?

      expect(event).not_to be_valid
      expect(event.errors).to include(:end_date)
    end

    it 'falso quando a data de fim do evento é anterior à data de inicio' do
      event = FactoryBot.build(:event, start_date: 2.days.from_now, end_date: 1.days.from_now)
      event.valid?

      expect(event).not_to be_valid
      expect(event.errors).to include(:start_date)
    end
  end

  it 'status deve ser "draft" por padrão' do
    event = FactoryBot.build(:event)
    event.valid?

    expect(event.status).to eq "draft"
  end

  it 'endereço deve ser obrigatório somente quando o evento for presencial ou hibrido' do
    event = FactoryBot.build(:event, event_type: :online, address: '')
    event.valid?

    expect(event.errors).not_to include(:address)
    expect(event).to be_valid
  end

  it 'deve limitar o numero de participantes para 30 caso não esteja autenticado' do
    user = FactoryBot.build(:user, verification_status: :unverified)
    event = FactoryBot.build(:event, participants_limit: 31, user: user)
    event.valid?

    expect(event.errors[:participants_limit]).to include 'do evento não pode ser maior que 30 para usuários não verificados'
    expect(event).not_to be_valid
  end


  it 'deve criar automaticamente uma agenda para cada dia do evento' do
    create(:event, start_date: 1.days.from_now, end_date: 3.days.from_now)

    expect(Schedule.count).to eq 3
  end

  it 'deve criar um code antes de salvar o evento' do
    event = build(:event)
    event.valid?

    expect(event.code).not_to be_nil
  end

  it 'Não deve criar um code igual ao existente' do
    existing_code = SecureRandom.alphanumeric(8).upcase
    create(:event, code: existing_code)
    category = create(:category, name: 'Pirâmide')
    event = build(:event, categories: [ category ], code: existing_code)
    event.valid?

    expect(event.code).not_to eq(existing_code)
  end

  context 'feedbacks do evento' do
    it 'e retorna com sucesso' do
      event = create(:event)
      url = "http://localhost:3000/api/v1/events/#{event.code}/feedbacks"
      feedbacks = {
        feedbacks: [
          {
            id: 1,
            title: 'Feedback 1',
            comment: 'comentário',
            mark: 3,
            user: 'Jaison'
          },
          {
            id: 2,
            title: 'Feedback 2',
            comment: 'comentário',
            mark: 1,
            user: 'Caio'
          }
        ]
      }
      response = double('response', status: 200, body: feedbacks.to_json)
      allow_any_instance_of(Faraday::Connection).to receive(:get).with(url).and_return(response)
      result = event.feedbacks

      expect(result[0].id).to eq 1
      expect(result[0].title).to eq 'Feedback 1'
      expect(result[0].comment).to eq 'comentário'
      expect(result[0].mark).to eq 3
      expect(result[0].participant_username).to eq 'Jaison'

      expect(result[1].id).to eq 2
      expect(result[1].title).to eq 'Feedback 2'
      expect(result[1].comment).to eq 'comentário'
      expect(result[1].mark).to eq 1
      expect(result[1].participant_username).to eq 'Caio'
    end

    it 'retorna array vazio caso de erro' do
      event = create(:event)
      url = "http://localhost:3000/api/v1/events/#{event.code}/feedbacks"
      response = double('response', body: "{}", status: 500)
      allow(Faraday).to receive(:get).with(url).and_return(response)
      allow(response).to receive(:success?).and_return(false)

      result = event.feedbacks

      expect(result.length).to eq 0
    end
  end
end
