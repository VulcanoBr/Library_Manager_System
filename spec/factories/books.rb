require 'faker'

FactoryBot.define do
  factory :book do
    isbn { Faker::Code.unique.isbn }
    title { Faker::Book.unique.title }
    published { Faker::Date.between(from: '1959-01-01', to: '2023-12-31') }
    publication_date { Faker::Date.between(from: '1959-01-01', to: '2023-12-31') }
    edition { '1ª edição' }
    cover { Faker::File.file_name }
    summary { Faker::Lorem.paragraphs(number: 4).join(' ') }
    special_collection { Faker::Boolean.boolean }
    count { 4 }
    association :library, factory: :library
    association :subject, factory: :subject
    association :language, factory: :language
    association :publisher, factory: :publisher
    association :author, factory: :author
   
  end
end
