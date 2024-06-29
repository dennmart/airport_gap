class AddUniqueIndexForAirports < ActiveRecord::Migration[7.1]
  def change
    remove_index :airports, :iata
    add_index :airports, :iata, unique: true
  end
end
