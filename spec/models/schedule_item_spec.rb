require 'rails_helper'

RSpec.describe ScheduleItem, type: :model do
  describe '#valid?' do
    context 'presença' do
      it 'inválido quando o nome está vazio' do
        schedule_item = build(:schedule_item, name: '')
        schedule_item.valid?

        expect(schedule_item.errors[:name]).to include 'não pode ficar em branco'
      end

      it 'inválido quando o tipo de agendamento está vazio' do
        schedule_item = build(:schedule_item, schedule_type: '')
        schedule_item.valid?

        expect(schedule_item.errors[:schedule_type]).to include 'não pode ficar em branco'
      end

      it 'inválido quando o horário de início está vazio' do
        schedule_item = build(:schedule_item, start_time: '')
        schedule_item.valid?

        expect(schedule_item.errors[:start_time]).to include 'não pode ficar em branco'
      end

      it 'inválido quando o horário de término está vazio' do
        schedule_item = build(:schedule_item, end_time: '')
        schedule_item.valid?

        expect(schedule_item.errors[:end_time]).to include 'não pode ficar em branco'
      end

      context 'quando é uma atividade' do
        it 'devem ser preenchido o campo de descrição' do
          schedule_item = build(:schedule_item, schedule_type: :activity, description: '')
          schedule_item.valid?

          expect(schedule_item.errors[:description]).to include 'não pode ficar em branco'
        end

        it 'devem ser preenchido o campo de nome do responsável' do
          schedule_item = build(:schedule_item, schedule_type: :activity, responsible_name: '')
          schedule_item.valid?

          expect(schedule_item.errors[:responsible_name]).to include 'não pode ficar em branco'
        end

        it 'devem ser preenchido o campo de e-mail do responsável' do
          schedule_item = build(:schedule_item, schedule_type: :activity, responsible_email: '')
          schedule_item.valid?

          expect(schedule_item.errors[:responsible_email]).to include 'não pode ficar em branco'
        end
      end

      context 'quando é um intervalo' do
        it 'não necessita preencher o campo de descrição' do
          schedule_item = build(:schedule_item, schedule_type: :interval, description: '')
          schedule_item.valid?

          expect(schedule_item.errors[:description]).to be_empty
        end

        it 'não necessita preencher o campo de nome do responsável' do
          schedule_item = build(:schedule_item, schedule_type: :interval, responsible_name: '')
          schedule_item.valid?

          expect(schedule_item.errors[:responsible_name]).to be_empty
        end

        it 'não necessita preencher o campo de e-mail do responsável' do
          schedule_item = build(:schedule_item, schedule_type: :interval, responsible_email: '')
          schedule_item.valid?

          expect(schedule_item.errors[:responsible_email]).to be_empty
        end
      end
    end

    context 'datas e horários' do
      it 'inválidos quando a data/horário de início é maior que a data/horário de término' do
        schedule_item = build(:schedule_item,
          start_time: (Time.now + 2.day).change(hour: 8, min: 0, sec: 0),
          end_time: (Time.now + 1.day).change(hour: 8, min: 0, sec: 0)
        )
        schedule_item.valid?

        expect(schedule_item.errors[:end_time]).to include 'deve ser depois do início'
      end

      it 'válidos quando a data/horário de início é menor que a data/horário de término' do
        schedule_item = build(:schedule_item,
          start_time: (Time.now + 1.day).change(hour: 8, min: 0, sec: 0),
          end_time: (Time.now + 2.day).change(hour: 8, min: 0, sec: 0)
        )
        schedule_item.valid?

        expect(schedule_item.errors[:end_time]).to be_empty
      end

      it 'inválido quando há conflito de horários com outro item' do
        schedule = create(:schedule)
        create(:schedule_item, schedule: schedule,
                               start_time: (Time.now + 1.day).change(hour: 8, min: 0, sec: 0),
                               end_time: (Time.now + 1.day).change(hour: 10, min: 0, sec: 0))

        schedule_item = build(:schedule_item, schedule: schedule,
                               start_time: (Time.now + 1.day).change(hour: 9, min: 0, sec: 0),
                               end_time: (Time.now + 1.day).change(hour: 11, min: 0, sec: 0))
        schedule_item.valid?

        expect(schedule_item.errors[:start_time]).to include 'não pode conflitar com horários de outros itens'
      end

      it 'válido quando não há conflito de horários com outros itens' do
        schedule = create(:schedule)
        create(:schedule_item, schedule: schedule,
                               start_time: (Time.now + 1.day).change(hour: 8, min: 0, sec: 0),
                               end_time: (Time.now + 1.day).change(hour: 10, min: 0, sec: 0))

        schedule_item = build(:schedule_item, schedule: schedule,
                               start_time: (Time.now + 1.day).change(hour: 10, min: 0, sec: 0),
                               end_time: (Time.now + 1.day).change(hour: 12, min: 0, sec: 0))
        schedule_item.valid?

        expect(schedule_item.errors[:base]).to be_empty
      end
    end
  end

  describe 'Cria um anuncio oficial' do
    it 'cria um anúncio oficial quando um item de agenda é atualizado' do
      user = create(:user)
      event = create(:event, user: user)
      schedule = create(:schedule, event: event)
      schedule_item = create(:schedule_item, schedule: schedule, name: 'Atividade Antiga')

      schedule_item.update(name: 'Novo Nome')

      expect(event.announcements.count).to eq(1)

      announcement = event.announcements.last
      expect(announcement.title).to eq('Atualização na atividade Novo Nome')
      expect(announcement.description.to_plain_text).to include("Nome alterado de 'Atividade Antiga' para 'Novo Nome'")
    end

    it 'não cria um anúncio se não houver alterações relevantes' do
      user = create(:user)
      event = create(:event, user: user)
      schedule = create(:schedule, event: event)
      schedule_item = create(:schedule_item, schedule: schedule, name: 'Atividade Antiga')

      schedule_item.update(name: 'Atividade Antiga')

      expect(event.announcements.count).to eq(0)
    end

    it 'cria um anúncio com múltiplas mudanças' do
      user = create(:user)
      event = create(:event, user: user)
      schedule = create(:schedule, event: event)
      schedule_item = create(:schedule_item,
        schedule: schedule,
        name: 'Atividade Antiga',
        start_time: '2025-02-10 09:00:00',
        end_time: '2025-02-10 10:00:00'
      )

      schedule_item.update(
        name: 'Nova Atividade',
        start_time: '2025-02-10 10:30:00',
        end_time: '2025-02-10 11:30:00'
      )

      expect(event.announcements.count).to eq(1)

      announcement = event.announcements.last
      expect(announcement.title).to eq('Atualização na atividade Nova Atividade')
      description_text = announcement.description.to_plain_text
      expect(description_text).to include("Nome alterado de 'Atividade Antiga' para 'Nova Atividade'")
      expect(description_text).to include("Início alterado de '09:00' para '10:30'")
      expect(description_text).to include("Término alterado de '10:00' para '11:30'")
    end
  end
end
