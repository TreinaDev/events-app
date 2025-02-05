require 'rails_helper'

RSpec.describe Announcement, type: :model do
  describe '#valid?' do
    it 'falha quando o título está vazio' do
      announcement = build(:announcement, title: '')
      announcement.valid?

      expect(announcement.errors[:title]).to include 'não pode ficar em branco'
    end

    it 'falha quando descrição está vazia' do
      announcement = build(:announcement, title: '')
      announcement.valid?

      expect(announcement.errors[:description]).to include 'não pode ficar em branco'
    end
  end
end
