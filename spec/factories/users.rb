FactoryBot.define do
  factory(:user) do
    email { 'alice@email.com' }
    password { 'password123' }
    password_confirmation { 'password123' }
    name { 'Alice' }
    family_name { 'Moreno' }
    registration_number { CPF.generate }

    trait :admin do
      confirmed_at { Time.now }
    end
  end
end
