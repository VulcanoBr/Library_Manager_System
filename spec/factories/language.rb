require 'faker'

FactoryBot.define do
  factory :language do
    sequence(:name) { |n| "#{Faker::Nation.language}-#{n}" }
  end
end