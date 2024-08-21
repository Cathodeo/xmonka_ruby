class Element < ApplicationRecord
  self.primary_key = 'id'

  def self.element_matchup(element1, element2, damage)
    if element1 == 3 && element2 == 2 || element1 == 4 && element2 == 1
      damage = damage * 2
      puts "Doubled damage due to weakness!"
    end
    if element1 == 4 && element2 == 2 || element1 == 3 && element2 == 1
      damage = round(damage / 2)
      puts "Halved damage due to resistance!"
    end
  end
end
