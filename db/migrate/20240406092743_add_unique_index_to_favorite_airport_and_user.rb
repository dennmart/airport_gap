class AddUniqueIndexToFavoriteAirportAndUser < ActiveRecord::Migration[7.1]
  def change
    add_index :favorites, [:airport_id, :user_id], unique: true
  end
end
