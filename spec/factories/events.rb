FactoryBot.define do
  factory :event do
    name { "MyString" }
    user { nil }
    type { 1 }
    address { "MyString" }
    participants_limit { 1 }
    url { "MyString" }
    status { 1 }
  end
end
