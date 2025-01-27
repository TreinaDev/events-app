FactoryBot.define do
  factory :schedule_item do
    name { "Palestra" }
    description { "alguma descrição" }
    start_time { (Time.now + 1.day).change(hour: 9, min: 0, sec: 0) }
    end_time { (Time.now + 1.day).change(hour: 10, min: 0, sec: 0) }
    responsible_name { "José" }
    responsible_email { "jose@email.com" }
    schedule_type { 0 }

    association :schedule
  end
end
