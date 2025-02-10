FactoryBot.define do
  factory :event do
    name { "Lollapalooza" }
    event_type { :inperson }
    participants_limit { 30 }
    description { "Um festival daora" }
    url { "http://Lollapalooza.com" }
    association :user
    start_date { (Time.now + 4.weeks) }
    end_date { (Time.now + 5.weeks) }
    banner { File.open(Rails.root.join('spec/support/images/banner.png'), filename: 'banner.png') }
    logo { File.open(Rails.root.join('spec/support/images/logo.jpg'), filename: 'logo.jpg') }
    categories { [ create(:category) ] }

    after(:build) do |event|
      if event.inperson? || event.hybrid?
        event.event_place ||= build(:event_place, user: event.user)
      end
    end
  end
end
