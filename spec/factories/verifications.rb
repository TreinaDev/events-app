FactoryBot.define do
  factory :verification do
    user { nil }
    status { 1 }
    comment { "MyString" }
    reviewed_by { nil }
  end
end
