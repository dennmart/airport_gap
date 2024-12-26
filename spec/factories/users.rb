FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    token { SecureRandom.base58 }
    password { 'airport-gap-123' }
  end
end
