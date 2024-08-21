class Monster < ApplicationRecord
  self.primary_key = 'id'


  def self.element_by_id(card_id)
    element = Monster.where(id: card_id).pluck(:element_id).first
    Element.where(id: element).pluck(:id).first
  end

  def self.max_hp_by_id(card_id)
    Monster.where(id: card_id).pluck(:healthpoints)
  end

end
