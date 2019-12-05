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
