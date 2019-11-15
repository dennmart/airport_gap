class CreateFavorites < ActiveRecord::Migration[6.0]
  def change
    create_table :favorites do |t|
      t.integer :user_id, index: true
      t.integer :airport_id
      t.text :note
      t.timestamps
    end
  end
end
