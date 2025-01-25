FactoryBot.define do
  factory :schedule do
    start_date { (Time.now + 1.day).change(hour: 8, min: 0, sec: 0) }
    end_date { (Time.now + 3.day).change(hour: 18, min: 0, sec: 0) }
    association :event
  end
end
