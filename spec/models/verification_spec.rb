require 'rails_helper'

RSpec.describe Verification, type: :model do
  describe 'recebe um status' do
    it 'padrão de pendente quando criado' do
      user = create(:user)
      verification = Verification.new(user: user)

      expect(verification.status).to eq("pending")
    end
  end
end
