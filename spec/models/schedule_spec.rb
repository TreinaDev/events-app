require 'rails_helper'

RSpec.describe Schedule, type: :model do
  describe "#valid?" do
    it "falso quando data de inicio não está preenchida" do
      schedule = build(:schedule, start_date: '')
      schedule.valid?

      expect(schedule.errors[:start_date]). to include 'não pode ficar em branco'
      expect(schedule).not_to be_valid
    end

    it "falso quando data de fim não está preenchida" do
      schedule = build(:schedule, end_date: '')
      schedule.valid?

      expect(schedule.errors[:end_date]). to include 'não pode ficar em branco'
      expect(schedule).not_to be_valid
    end

    it "falso quando data de inicio vem depois da data de fim" do
      schedule = build(:schedule, start_date: (Time.now + 2.day).change(hour: 8, min: 0, sec: 0), end_date: (Time.now + 1.day).change(hour: 8, min: 0, sec: 0))
      schedule.valid?

      expect(schedule.errors[:start_date]). to include 'deve vir antes da data de fim'
      expect(schedule).not_to be_valid
    end
  end
end
