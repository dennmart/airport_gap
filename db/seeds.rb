require "csv"

puts "=========================================="
puts "Importing airport data..."
Airport.delete_all
CSV.foreach(Rails.root.join("db", "airports.csv"), headers: true) do |row|
  next if row["iata"].blank?

  Airport.create(
    name: row["name"],
    city: row["city"],
    country: row["country"],
    iata: row["iata"],
    icao: row["icao"],
    latitude: row["latitude"],
    longitude: row["longitude"],
    altitude: row["altitude"],
    timezone: row["timezone"]
  )
end
puts "Done importing airport data!"
puts "==========================================\n\n"

puts "=========================================="
puts "Creating user..."
user = User.find_or_create_by(email: "dennis@dev-tester.com")
puts "Done creating user!\n"
puts "Email: #{user.email}"
puts "Token: #{user.token}"
puts "==========================================\n\n"

puts "=========================================="
puts "Creating favorites for user..."
Favorite.delete_all
Airport.order("RANDOM()").limit(10).each do |airport|
  Favorite.create(user: user, airport: airport)
end
puts "Done creating favorites!"
puts "==========================================\n\n"
