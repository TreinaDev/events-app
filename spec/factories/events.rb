FactoryBot.define do
  factory :event do
    name { "Lollapalooza" }
    event_type { :inperson }
    address { "Av dos Bancos" }
    participants_limit { 30 }
    url { "http://Lollapalooza.com" }
    association :user
    start_date { (Time.now + 1.day).change(hour: 8, min: 0, sec: 0) }
    end_date { (Time.now + 3.day).change(hour: 18, min: 0, sec: 0) }

    categories { [ create(:category) ] }
  end
end
