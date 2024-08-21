# app/models/card.rb
class Card < ApplicationRecord
  has_one :monster, dependent: :destroy
end
