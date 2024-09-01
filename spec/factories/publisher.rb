require 'faker'

FactoryBot.define do
  factory :publisher do
    sequence(:name) { |n| "#{Faker::Book.publisher}#{n}" }
    sequence(:website) { |x| "www.website_publisher#{x}.com" } 
    email { Faker::Internet.email }
  end
end