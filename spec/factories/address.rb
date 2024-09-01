require 'faker'

FactoryBot.define do
  factory :address do
    street { Faker::Address.street_address }
    number { Faker::Address.building_number }
    complement { Faker::Address.secondary_address }
    neighborhood { Faker::Address.community }
    city { Faker::Address.city }
    state { Faker::Address.state }
    country { Faker::Address.country }
    zipcode { Faker::Address.zip_code }
    association :university, factory: :universityty
  end
end