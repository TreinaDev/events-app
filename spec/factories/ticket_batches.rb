FactoryBot.define do
  factory :ticket_batch do
    name { "MyString" }
    tickets_limit { 1 }
    start_date { "2025-01-23" }
    end_date { "2025-01-23" }
    ticket_price { "9.99" }
    discount_option { 1 }
    event { nil }
  end
end
