FactoryBot.define do
  factory :event_place_recommendation do
    name { "Restaurante 5 Estrelas" }
    full_address { "Rua do povo 123" }
    phone { "51999999999" }
    event_place { nil }
  end
end
