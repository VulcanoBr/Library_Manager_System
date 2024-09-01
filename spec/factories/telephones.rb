require 'faker'

FactoryBot.define do
  factory :telephone do
    phone { Faker::PhoneNumber.cell_phone }
    email_contact { Faker::Internet.email }
    contact { Faker::Name.unique.name }
    association :university, factory: :university
  end
end