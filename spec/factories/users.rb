FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    token { SecureRandom::base58 }
  end
end
