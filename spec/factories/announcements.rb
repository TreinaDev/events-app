FactoryBot.define do
  factory :announcement do
    title { "Conheça o Lolla Transfer e o Lolla Express!" }
    association :event
    association :user
    description { "Veja se está perto de você" }
  end
end
