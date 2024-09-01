require 'faker'

FactoryBot.define do
  factory :education_level do
    sequence(:name) { |n| "#{Faker::Name.name}-#{n}" }
  end
end
