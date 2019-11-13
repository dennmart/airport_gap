FactoryBot.define do
  factory :airport do
    name { "#{Faker::Name.name} Airport" }
    city { Faker::Address.city }
    country { Faker::Address.country }
    iata { ('A'..'Z').to_a.shuffle[0, 3].join }
    icao { ('A'..'Z').to_a.shuffle[0, 4].join }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    altitude { rand(0..29035) }
    timezone { Faker::Address.time_zone }
  end
end
