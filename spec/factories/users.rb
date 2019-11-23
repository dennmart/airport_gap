FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    token { SecureRandom::base58 }
    password { "airport-gap-123" }

    trait :with_password_reset do
      password_reset_token { SecureRandom.urlsafe_base64 }
      password_reset_sent_at { Time.current }
    end
  end
end
