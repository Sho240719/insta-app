FactoryBot.define do
  factory :post do
    content { Faker::Lorem.characters(number: 20) }
  end
end
