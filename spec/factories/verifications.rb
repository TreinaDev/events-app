FactoryBot.define do
  factory :verification do
    user { nil }
    status { 1 }
    comment { "Comentário de revisão" }
    reviewed_by { nil }
  end
end
