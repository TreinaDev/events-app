require 'rails_helper'

RSpec.describe Schedule, type: :model do
  describe "#valid?" do
    it "falso quando data não está preenchida" do
      schedule = build(:schedule, date: '')
      schedule.valid?

      expect(schedule.errors[:date]). to include 'não pode ficar em branco'
      expect(schedule).not_to be_valid
    end
  end
end
