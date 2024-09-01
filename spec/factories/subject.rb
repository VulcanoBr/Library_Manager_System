require 'faker'

FactoryBot.define do
  factory :subject do
    sequence(:name) { |n| "#{Faker::Book.genre}-#{n}" }
  end
end