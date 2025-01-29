require 'rails_helper'

RSpec.describe Speaker, type: :model do
  describe '#valid' do
    context 'presença de atributo' do
      it 'falso quando nome está vazio' do
        speaker = Speaker.new(name: '', email: "marcos@email.com")

        expect(speaker).to_not be_valid
      end

      it 'falso quando email está vazio' do
        speaker = Speaker.new(email: '', name: "marcos")

        expect(speaker).to_not be_valid
      end

      it 'falso quando token não é gerado' do
        speaker = Speaker.new(name: 'Marcos', email: 'marcos@email.com')
        result = speaker.token.present?

        expect(result).to eq true
      end
    end

    context 'atributo único' do
      it 'gera token único e aleatório' do
        first_speaker = Speaker.create!(name: 'Marcos', email: 'marcos@email.com')
        second_speaker = Speaker.new(name: 'Gabriel', email: 'gabriel@email.com')

        expect(first_speaker.token).to_not eq second_speaker.token
      end
    end
  end
end
