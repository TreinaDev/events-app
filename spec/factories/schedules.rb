FactoryBot.define do
  factory :schedule do
    date { (Time.now + 1.day).change(hour: 8, min: 0, sec: 0) }
    association :event
  end
end
