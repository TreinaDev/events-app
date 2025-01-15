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

    it 'false when logo has an invalid format' do
      event = FactoryBot.build(:event)
      event.logo.attach(io: File.open('spec/support/test_file.txt'), filename: 'test_file.txt', content_type: 'text/plain')

      expect(event.valid?).to eq false
    end

    it 'false when banner has an invalid format' do
      event = FactoryBot.build(:event)
      event.banner.attach(io: File.open('spec/support/test_file.txt'), filename: 'test_file.txt', content_type: 'text/plain')

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
