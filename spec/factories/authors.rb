# spec/factories/author.rb
require 'faker'

FactoryBot.define do
  factory :author do
    sequence(:name) { |n| "#{Faker::Book.author}#{n}" }
    sequence(:website) { |z| "www.website_example_author#{z}.com" } 
    email { Faker::Internet.email }
    association :nationality, factory: :nationality
  end
end