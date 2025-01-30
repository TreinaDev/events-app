FactoryBot.define do
  factory :event do
    name { "Lollapalooza" }
    event_type { :inperson }
    address { "Av dos Bancos" }
    participants_limit { 30 }
    url { "http://Lollapalooza.com" }
    association :user
    start_date { (Time.now + 4.weeks) }
    end_date { (Time.now + 5.weeks) }

    categories { [ create(:category) ] }
  end
end
