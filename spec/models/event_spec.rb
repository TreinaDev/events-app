require 'rails_helper'

RSpec.describe Event, type: :model do
  describe '#valid' do
    it 'falso quando nome não está preenchido' do
      event = FactoryBot.build(:event, name: '')
      expect(event.valid?).to eq false
    end

    it 'falso quando endereço não está preenchido' do
      event = FactoryBot.build(:event, address: '')

      expect(event.valid?).to eq false
    end

    it 'falso quando limite de participantes não está preenchido' do
      event = FactoryBot.build(:event, participants_limit: '')
      expect(event.valid?).to eq false
    end

    it 'falso quando url do evento não está preenchido' do
      event = FactoryBot.build(:event, url: '')
      expect(event.valid?).to eq false
    end

    it 'falso quando a logo possui um formato inválido' do
      event = FactoryBot.build(:event)
      event.logo.attach(io: File.open('spec/support/test_file.txt'), filename: 'test_file.txt', content_type: 'text/plain')

      expect(event.valid?).to eq false
    end

    it 'falso quando banner possui um formato inválido' do
      event = FactoryBot.build(:event)
      event.banner.attach(io: File.open('spec/support/test_file.txt'), filename: 'test_file.txt', content_type: 'text/plain')

      expect(event.valid?).to eq false
    end

    it 'falso quando não possui ao menos 1 categoria' do
      event = FactoryBot.build(:event)
      event.banner.attach(io: File.open('spec/support/test_file.txt'), filename: 'test_file.txt', content_type: 'text/plain')

      expect(event.valid?).to eq false
    end
  end

  it 'status deve ser "draft" por padrão' do
    event = FactoryBot.build(:event)
    expect(event.status).to eq "draft"
  end

  it 'endereço deve ser obrigatório somente quando o evento for presencial ou hibrido' do
    event = FactoryBot.build(:event, event_type: :online, address: '')

    expect(event.valid?).to eq true
  end

  it 'deve limitar o numero de participantes para 30 caso não esteja autenticado' do
    user = FactoryBot.build(:user, verification_status: :unverified)
    event = FactoryBot.build(:event, participants_limit: 31, user: user)

    expect(event.valid?).to eq false
  end
end
