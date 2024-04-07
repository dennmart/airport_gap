class Airport < ApplicationRecord
  has_many :favorites, dependent: :destroy

  validates :name, :iata, presence: true
end
