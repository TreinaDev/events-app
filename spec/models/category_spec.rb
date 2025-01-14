require 'rails_helper'

RSpec.describe Category, type: :model do
  describe '#valid?' do
    it 'falha quando o nome está vazio' do
      category = Category.new(name: '')

      expect(category).to_not be_valid
    end
  end
end
