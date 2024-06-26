require 'csv'

puts '=========================================='
puts 'Seeding / resetting airport data...'

ActiveRecord::Base.connection_pool.with_connection { |conn| conn.execute('TRUNCATE airports RESTART IDENTITY') }

airports = []

CSV.foreach(Rails.root.join('db/airports.csv'), headers: true) do |row|
  next if row['iata'].blank?

  airports << {
    name: row['name'],
    city: row['city'],
    country: row['country'],
    iata: row['iata'],
    icao: row['icao'],
    latitude: row['latitude'],
    longitude: row['longitude'],
    altitude: row['altitude'],
    timezone: row['timezone']
  }
end

Airport.insert_all!(airports)

puts 'Done importing airport data!'
puts "==========================================\n\n"

puts '=========================================='
puts 'Creating example user...'
user = User.find_or_create_by(email: 'airportgap@dev-tester.com') do |u|
  u.password = 'airportgap123'
end
puts "Done creating example user!\n"
puts "Email: #{user.email}"
puts 'Password: airportgap123'
puts "Token: #{user.token}"
puts "==========================================\n\n"

puts '=========================================='
puts 'Creating 10 favorites for example user...'
Favorite.delete_all
Airport.order('RANDOM()').limit(10).each do |airport|
  Favorite.create(user: user, airport: airport)
end
puts 'Done creating favorites!'
puts "==========================================\n\n"
