# app/models/card.rb
class Card < ApplicationRecord
  has_one :monster, dependent: :destroy

  validates :card_type, presence: true
  validates :card_location, presence: true
  validates :ismonster, presence: true
end
