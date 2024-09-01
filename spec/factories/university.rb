require 'faker'

FactoryBot.define do
  factory :university do
    name { Faker::University.unique.name }
    email { Faker::Internet.email }
    identification { "99.999.999/0001-99" }
    sequence(:homepage) { |n| "www.example_university#{n}.com" } 
  end
end
