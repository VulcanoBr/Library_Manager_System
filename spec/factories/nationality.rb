require 'faker'

FactoryBot.define do
  factory :nationality do
    sequence(:name) { |n| "#{Faker::Nation.nationality}-#{n}" }
  end
end
