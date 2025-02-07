FactoryBot.define do
  factory :event_place do
    sequence(:name) { |n| "Arena de Grêmio #{n}" }
    street { "Av. Padre Leopoldo Brentano" }
    sequence(:number) { |n| "#{110 + n}" }
    neighborhood { "Farrapos" }
    city { "Porto Alegre" }
    zip_code { "90250590" }
    state { "RS" }
    user { create(:user) }
  end
end
