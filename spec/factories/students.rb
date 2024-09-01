require 'faker'

FactoryBot.define do
  factory :student do
    name { Faker::Name.unique.name }
    identification { Faker::IDNumber.brazilian_citizen_number(formatted: true) }
    email { Faker::Internet.email }
    password { "12345678" }
    phone { Faker::PhoneNumber.cell_phone }
    max_book_allowed { 4 }
    google_token { "" }
    google_refresh_token { "" }
    provider { " " }
    uid { "" }
    association :university, factory: :university
    association :education_level, factory: :education_level
  end
end
