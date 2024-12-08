FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.characters(number: 10) }
  end
end
