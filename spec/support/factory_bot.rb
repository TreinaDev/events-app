FactoryBot.define do
  sequence :seq_email do |n|
    "user#{n}@example.com"
  end
end
