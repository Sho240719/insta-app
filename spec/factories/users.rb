FactoryBot.define do
  factory :user do
    account_name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password' }
  end
end
