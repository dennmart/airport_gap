FactoryBot.define do
  factory :favorite do
    association :user
    association :airport
    note { Faker::Lorem.sentence(word_count: 20) }
  end
end
