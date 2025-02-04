FactoryBot.define do
  factory :user_address do
    street { "Rua das Laranjeiras" }
    number { 522 }
    district { "Laranjeiras" }
    city { "Rio de Janeiro" }
    state { "RJ" }
    zip_code { "37.000-000" }
    user { nil }
  end
end
