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
    banner { File.open(Rails.root.join('spec/support/images/no_banner.png'), filename: 'no_banner.png') }
    logo { File.open(Rails.root.join('spec/support/images/no_logo.png'), filename: 'no_logo.png') }

    categories { [ create(:category) ] }
  end
end
