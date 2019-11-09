class Airport < ApplicationRecord
  validates :name, :iata, presence: true
end
