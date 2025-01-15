FactoryBot.define do
  factory(:user) do
    email { 'wg0Hl@example.com' }
    password { 'password123' }
    password_confirmation { 'password123' }
    name { 'Alice' }
    family_name { 'Moreno' }
    registration_number { CPF.generate }
    role { 1 }
    verification_status { 1 }
  end
end
