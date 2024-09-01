require 'faker'

FactoryBot.define do
  factory :library do
    name { Faker::Company.unique.name }
    email { Faker::Internet.email }
    location { Faker::Address.city }
    borrow_limit { Faker::Number.between(from: 1, to: 10) }
    overdue_fines { Faker::Number.decimal(l_digits: 1, r_digits: 2) }
    association :university, factory: :university
  end
end
