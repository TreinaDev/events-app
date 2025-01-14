require 'rails_helper'

RSpec.describe Event, type: :model do
  describe '#valid' do
    it 'false when name is not present' do
      event = Event.new(event_type: "inperson", address: "Av dos Bancos", participants_limit: 30, url: "http::/evento.com", status: "draft")

      expect(event.valid?).to eq false
    end

    it 'false when address is not present' do
      event = Event.new(name: "Festa", event_type: "inperson", participants_limit: 30, url: "http::/evento.com", status: "draft")

      expect(event.valid?).to eq false
    end

    it 'false when participants_limit is not present' do
      event = Event.new(name: "Festa", event_type: "inperson", address: "Av dos Bancos", url: "http::/evento.com", status: "draft")

      expect(event.valid?).to eq false
    end

    it 'false when url is not present' do
      event = Event.new(name: "Festa", event_type: "inperson", address: "Av dos Bancos", participants_limit: 30,  status: "draft")

      expect(event.valid?).to eq false
    end
  end

  it 'status should be draft by default' do
    event = Event.new(name: "Festa", event_type: "inperson", address: "Av dos Bancos", participants_limit: 30, url: "http::/evento.com")

    expect(event.status).to eq "draft"
  end
end
