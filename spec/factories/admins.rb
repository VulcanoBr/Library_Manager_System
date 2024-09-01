require 'faker'

FactoryBot.define do
  factory :admin do
    name { Faker::Name.unique.name }
    identification { Faker::IDNumber.brazilian_citizen_number(formatted: true) }
    email { Faker::Internet.email }
    password { "12345678" }
    encrypted_password { "" }
    reset_password_token { "" }
  end
end
