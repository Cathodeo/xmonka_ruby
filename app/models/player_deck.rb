class PlayerDeck < ApplicationRecord
  belongs_to :user
  serialize :deck_data, coder: YAML
end
