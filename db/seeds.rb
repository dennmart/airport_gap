puts '=========================================='
puts 'Seeding / resetting airport data...'

ActiveRecord::Base.connection_pool.with_connection { |conn| conn.execute('TRUNCATE airports RESTART IDENTITY') }

Rake::Task['airports:refresh'].invoke

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
