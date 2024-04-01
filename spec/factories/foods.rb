FactoryBot.define do
  factory :food do
    sequence(:name) { |n| "food#{n}" }
    abb_name { "food" }
    price { 100 }
  end
end
