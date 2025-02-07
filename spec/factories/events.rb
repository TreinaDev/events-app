FactoryBot.define do
  factory :event do
    name { "Lollapalooza" }
    participants_limit { 30 }
    url { "http://Lollapalooza.com" }
    association :user
    start_date { (Time.now + 4.weeks) }
    end_date { (Time.now + 5.weeks) }
    banner { File.open(Rails.root.join('spec/support/images/no_banner.png'), filename: 'no_banner.png') }
    logo { File.open(Rails.root.join('spec/support/images/no_logo.png'), filename: 'no_logo.png') }
    event_place { create :event_place }

    categories { [ create(:category) ] }
  end
end
