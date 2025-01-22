require 'rails_helper'

RSpec.describe Keyword, type: :model do
  describe '#valid?' do
    it 'falha quando o nome está vazio' do
      keyword = Keyword.new(value: '')

      expect(keyword).to_not be_valid
    end

    it 'falha quando o nome é duplicado' do
      Keyword.create!(value: 'Backend')
      keyword = Keyword.new(value: 'Backend')

      expect(keyword).to_not be_valid
    end
  end
end
