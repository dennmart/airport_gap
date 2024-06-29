require 'csv'
require 'open-uri'

namespace :airports do # rubocop:disable Metrics/BlockLength
  desc 'Refresh airports data'
  task refresh: :environment do
    airports = []
    header_string = 'id,name,city,country,iata,icao,latitude,longitude,altitude,timezone,dst,tz,type,source\n'

    puts 'Downloading latest airport data...'
    airports_data = URI.open('https://raw.githubusercontent.com/jpatokal/openflights/master/data/airports.dat').read

    puts 'Parsing airport data...'
    parsed = CSV.parse(header_string + airports_data, headers: true)
    parsed.each do |row|
      next if row['iata'].blank? || row['iata'] == '\N'

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

    puts 'Upserting airport data...'
    Airport.upsert_all(airports, unique_by: :iata) # rubocop:disable Rails/SkipsModelValidations

    puts "Done updating airport data! (#{airports.size} airports processed)"
  end
end
