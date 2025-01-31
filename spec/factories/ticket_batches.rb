FactoryBot.define do
  factory :ticket_batch do
    name { "Primeiro Lote" }
    tickets_limit { 15 }
    start_date { (Time.now + 1.week) }
    end_date { (Time.now + 3.week) }
    ticket_price { "109.99" }
    discount_option { :student }
    event { create(:event) }
  end
end
