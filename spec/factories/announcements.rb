FactoryBot.define do
  factory :announcement do
    title { "Conheça o Lolla Transfer e o Lolla Express!" }
    association :event
    association :user
  end
end
