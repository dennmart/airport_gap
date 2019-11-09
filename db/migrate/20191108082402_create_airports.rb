class CreateAirports < ActiveRecord::Migration[6.0]
  def change
    create_table :airports do |t|
      t.string :name
      t.string :city
      t.string :country
      t.string :iata, index: true
      t.string :icao
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.integer :altitude
      t.string :timezone
    end
  end
end
