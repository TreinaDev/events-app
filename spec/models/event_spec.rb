require 'rails_helper'

RSpec.describe Event, type: :model do
  describe '#valid' do
    it 'false when name is not present' do
      event = FactoryBot.build(:event, name: '')
      expect(event.valid?).to eq false
    end

    it 'false when address is not present' do
      event = FactoryBot.build(:event, address: '')

      expect(event.valid?).to eq false
    end

    it 'false when participants_limit is not present' do
      event = FactoryBot.build(:event, participants_limit: '')
      expect(event.valid?).to eq false
    end

    it 'false when url is not present' do
      event = FactoryBot.build(:event, url: '')
      expect(event.valid?).to eq false
    end
  end

  it 'status should be draft by default' do
    event = FactoryBot.build(:event)
    expect(event.status).to eq "draft"
  end

  it 'address should be required only when event type is inperson or hybrid' do
    event = FactoryBot.build(:event, event_type: :online, address: '')

    expect(event.valid?).to eq true
  end
end
