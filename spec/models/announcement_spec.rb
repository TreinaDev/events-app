require 'rails_helper'

RSpec.describe Announcement, type: :model do
  describe '#valid?' do
    it 'falha quando o título está vazio' do
      announcement = build(:announcement, title: '')
      announcement.valid?

      expect(announcement.errors[:title]).to include 'não pode ficar em branco'
    end

    it 'falha quando descrição está vazia' do
      announcement = build(:announcement, description: '')
      announcement.valid?

      expect(announcement.errors[:description]).to include 'não pode ficar em branco'
    end
  end

  context 'atributo único' do
    it 'gera code único e aleatório' do
      category = Category.create!(name: 'Geek')
      event_manager = create(:user, email: 'teste@email.com')
      event = create(:event, name: 'ccxp', status: :published, user: event_manager, categories: [ category ])
      first_announcement = create(:announcement, title: 'Distribuição de cartas One Piece', user: event_manager, event: event, description: 'perto do palco principal')
      second_announcement = build(:announcement)

      expect(first_announcement.code).to_not eq second_announcement.code
    end
  end
end
