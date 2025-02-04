FactoryBot.define do
  factory :event_place do
    name { "Arena de Grêmio" }
    street { "Av. Padre Leopoldo Brentano" }
    number { "110" }
    neighborhood { "Farrapos" }
    city { "Porto Alegre" }
    zip_code { "90250590" }
    state { "RS" }
    user { create(:user) }
  end
end
