class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :airport

  validates :airport, uniqueness: { scope: :user }
end
