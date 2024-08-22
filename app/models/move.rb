class Move < ApplicationRecord
  self.primary_key = 'id'

  def name
    __method__
  end



  def self.element_monid(monid)
    Element.where(id: (Monster.where(id: monid).pluck(:element_id).first)).pluck(:id).first
  end

  def self.element_matchup(element1, element2, damage)
    if (element1 == 3 && element2 == 2) || (element1 == 4 && element2 == 1)
      damage *= 2
      puts "Doubled damage due to weakness!"
    elsif (element1 == 4 && element2 == 2) || (element1 == 3 && element2 == 1)
      damage = damage / 2
      puts "Halved damage due to resistance!"
    else
      # No change in damage if no matchup
    end

    return damage
  end


  def self.pestilence(player, target_key)
      puts "Pestilence is used!"
      # Poison the opponent's monster
      foe_element =  element_monid(player.which_monid)
      if foe_element == 2
        player.alter_status(target_key, 3, player)
        puts "Animal foe is poisoned!"
      end
      damage = element_matchup(3, foe_element, 3)
      player.damage_monster(target_key, damage, player)
    end

    def self.zapper(player, target_key)
      puts "#{name} is used!"
      foe_element =  element_monid(player.which_monid)
      result = coin_toss
      if result == :heads
        player.alter_status(target_key, 7, player)
        puts "Foe is confused!"
        damage = element_matchup(1, foe_element, 3)
        player.damage_monster(target_key, damage, player)
      else
        puts "Zapper missed!"
      end
    end

    def stompede(opponent)
      puts "#{name} is used!"
      # Force opponent to switch monsters
      opponent.force_switch_monster
      puts "Opponent switched their monster!"
    end

    def horned_tackle(opponent)
      puts "#{name} is used!"
      # Simple attack with no special effects
      damage_deal(opponent.monster, power)
    end

    def energy_transfer(user)
      puts "#{name} is used!"
      # Heal the user or a benched robot
      user.choose_heal_target.heal(1)
      puts "Energy transfer heals 1 HP!"
    end

    def rainbow_bomb(opponent)
      puts "#{name} is used!"
      # Simple powerful attack
      damage_deal(opponent.monster, power)
    end

    def null_frequency(opponent)
      puts "#{name} is used!"
      if opponent.monster.robot_type?
        damage_deal(opponent.monster, power)
      else
        puts "Move failed, non-Robot foe!"
      end
    end

    def droid_hammer(opponent)
      puts "#{name} is used!"
      result = coin_toss
      if result == :heads
        opponent.monster.apply_status(:stunned)
        puts "Foe is stunned for a turn!"
      end
    end

    def corroder(opponent)
      puts "#{name} is used!"
      multiplier = opponent.monster.robot_type? ? 2 : 1
      damage_deal(opponent.monster, power * multiplier)
    end

    def foul_gas(opponent)
      puts "#{name} is used!"
      multiplier = opponent.monster.poisoned? ? 2 : 1
      damage_deal(opponent.monster, power * multiplier)
    end

    def gooey_string(opponent)
      puts "#{name} is used!"
      # Prevent opponent from switching monsters
      opponent.monster.apply_status(:immobilized)
    end

    def irradiate(game)
      puts "#{name} is used!"
      # Create a field that deals passive damage
      game.create_field_effect(:irradiate)
      puts "Irradiate field effect is active!"
    end

    def sonar_scream(opponent)
      puts "#{name} is used!"
      # Reveal a card from the opponent's bench
      revealed_card = opponent.reveal_benched_card
      puts "Revealed card: #{revealed_card.name}"
    end

    def bombastic_rhythm(user, opponent)
      puts "#{name} is used!"
      result = coin_toss
      if result == :heads
        user.apply_status(:rhythm_locked)
        opponent.apply_status(:rhythm_locked)
        puts "Both players are locked into rhythm!"
      end
    end

    def position_alert(user)
      puts "#{name} is used!"
      user.draw_card
      result = coin_toss
      if result == :heads
        user.beacom.reduce_cooldown(0)
      end
    end

    def variable_wavelength(opponent)
      puts "#{name} is used!"
      damage = power
      2.times do
        result = coin_toss
        damage += 10 if result == :heads
      end
      damage_deal(opponent.monster, damage)
    end

    def inject_o_zooka(opponent)
      puts "#{name} is used!"
      result = coin_toss
      if result == :heads
        opponent.monster.apply_status(:poisoned)
      else
        opponent.monster.heal(1)
      end
    end

    def sulphur_rain(opponent)
      puts "#{name} is used!"
      opponent.benched_monsters.each do |monster|
        damage_deal(monster, 1)
      end
    end

    def stench_trail(opponent)
      puts "#{name} is used!"
      next_benched_monster = opponent.peek_next_benched_monster
      if next_benched_monster.biohazard_type?
        next_benched_monster.heal(1)
      elsif next_benched_monster.animal_type?
        damage_deal(next_benched_monster, 1)
      end
    end

    def curl(user, opponent)
      puts "#{name} is used!"
      result = coin_toss
      if result == :heads
        user.monster.add_defensive_shield(2)
      else
        user.monster.add_defensive_shield(1)
      end
    end

    def reu_teh(opponent)
      puts "#{name} is used!"
      # Consecutive attacks increase damage
      user.monster.increase_damage(1)
    end

    def kalashnicroc(opponent)
      puts "#{name} is used!"
      3.times do
        result = coin_toss
        damage_deal(opponent.monster, 2) if result == :tails
      end
    end

    def andean_spitfire(opponent)
      puts "#{name} is used!"
      result = coin_toss
      if result == :heads
        opponent.monster.discard_equipped_card
      end
    end

    def power_sucker(opponent)
      puts "#{name} is used!"
      if opponent.monster.robot_type? || opponent.monster.radio_type?
        opponent.monster.heal(2)
      end
    end

    def deus_volt(user)
      puts "#{name} is used!"
      # Create a protective shield
      user.monster.add_protective_shield(2, 3)
    end

    def head_or_tail(opponent)
      puts "#{name} is used!"
      result = coin_toss
      if result == :heads
        damage_deal(opponent.monster, power)
      else
        damage_deal(opponent.monster, power * 2)
        user.monster.receive_damage(2)
      end
    end

    private

    def self.coin_toss
      [:heads, :tails].sample
    end

  end




