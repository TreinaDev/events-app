FactoryBot.define do
  factory(:user) do
    sequence(:email) { |n| "user#{n}@example.com" }
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

    trait :with_pending_request do
      id_photo { File.open(Rails.root.join('spec/support/images/id_photo.png'), filename: 'id_photo.png') }
      address_proof { File.open(Rails.root.join('spec/support/images/address_proof.jpeg'), filename: 'address_proof.jpeg') }
      phone_number { '35 99988 7766' }
      verification_status { :pending }

      after(:build) do |user|
        create(:user_address, user: user)
        create(:verification, user: user, comment: '')
      end
    end
  end
end
