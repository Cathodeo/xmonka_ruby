# frozen_string_literal: true

class Deck


  attr_accessor :player_deck, :player_name
  def initialize
    @player_name = "Player1"
    @deck_size = 20
    @player_deck = {}
    @deck_size.times.map do |i|
      random = rand(1..14)
      monster_content = {}
      is_monster = false
        if Card.where(id: random).pluck(:cardtype).first == 1
          monster_content = {
            current_hp: Monster.where(id: Card.where(id: random).pluck(:foreign_id)).pluck(:healthpoints).first,
            status_id: 0,
            equipped_id: 0,
          }
          is_monster = true
        end
      hash_value = {card_id: random, monster_card: is_monster, monster_values: monster_content, position: :deck}
      @player_deck[i] = hash_value
    end
  end

  def initial_hand
    count = 0
    @player_deck.each do |key, subhash|
      if count < 5 && subhash[:position] != :hand
        subhash[:position] = :hand
        count += 1
      end
    end
  end

  def eligible_monsters
    @player_deck.values.select do |card_hash|
      card_hash[:monster_card] && card_hash[:position] == :hand
    end.map { |card_hash| card_hash[:card_id] }
  end

  def initialize_monster(chosen_monster_id)
    # Check if any card is already in the :gamearea
    any_in_gamearea = @player_deck.any? { |_key, subhash| subhash[:position] == :gamearea }

    # Iterate through the player deck and update the position of the chosen monster
    @player_deck.each do |key, subhash|
      if subhash[:card_id] == chosen_monster_id
        if any_in_gamearea
          subhash[:position] = :bench
        else
          subhash[:position] = :gamearea
        end
        break  # Stop after finding and updating the first match
      end
    end
  end





end
