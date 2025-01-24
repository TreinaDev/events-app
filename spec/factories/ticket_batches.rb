FactoryBot.define do
  factory :ticket_batch do
    name { "Primeiro Lote" }
    tickets_limit { 15 }
    start_date { 3.days.from_now.strftime('%Y-%m-%d') }
    end_date { 3.months.from_now.strftime('%Y-%m-%d') }
    ticket_price { "109.99" }
    discount_option { :student }
    event { create(:event) }
  end
end
