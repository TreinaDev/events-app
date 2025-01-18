FactoryBot.define do
  factory(:user) do
    email { 'alice@email.com' }
    password { 'password123' }
    password_confirmation { 'password123' }
    name { 'Alice' }
    family_name { 'Moreno' }
    registration_number { CPF.generate }

    trait :admin do
      email { 'alice@meuevento.com.br' }
      after(:build) do |user|
        user.confirm
      end
    end
  end
end
