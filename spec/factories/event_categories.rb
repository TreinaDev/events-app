FactoryBot.define do
  factory :event_category do
    association :event
    association :category
  end
end
