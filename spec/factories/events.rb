FactoryBot.define do
  factory :event do
    name { "Lollapalooza" }
    event_type { :inperson }
    address { "Av dos Bancos" }
    participants_limit { 30 }
    url { "http://Lollapalooza.com" }
    association :user

    categories { [ create(:category) ] }
  end
end
