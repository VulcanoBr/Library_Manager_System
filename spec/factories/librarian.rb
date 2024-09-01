require 'faker'

FactoryBot.define do
  factory :librarian do
    name { Faker::Name.unique.name }
    email { Faker::Internet.email }
    identification { Faker::IDNumber.brazilian_citizen_number(formatted: true) }
    password { "12345678" }
    phone { Faker::PhoneNumber.cell_phone }
    approved { true }
    association :library, factory: :library
  end
end
