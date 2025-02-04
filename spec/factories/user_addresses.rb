FactoryBot.define do
  factory :user_address do
    street { "MyString" }
    number { 1 }
    district { "MyString" }
    city { "MyString" }
    state { "MyString" }
    zip_code { "MyString" }
    user { nil }
  end
end
