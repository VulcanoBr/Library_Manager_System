
FactoryBot.define do
  factory :checkout do
    student
    book
    issue_date { "2023-11-15" }
    expected_return_date { "2023-11-30" }
    return_date { nil }
    validity { 15 }
  end
end
