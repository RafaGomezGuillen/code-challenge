FactoryBot.define do
  factory :product do
    sequence(:code) { |n| "P#{n}" }
    sequence(:name) { |n| "Product #{n}" }
    price { 10.0 }
  end
end
