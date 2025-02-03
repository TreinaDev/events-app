FactoryBot.define do
  factory :event_place do
    name { "MyString" }
    street { "MyString" }
    number { "MyString" }
    neighborhood { "MyString" }
    city { "MyString" }
    zip_code { "MyString" }
    state { "MyString" }
    user { nil }
  end
end
