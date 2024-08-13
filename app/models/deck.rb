# frozen_string_literal: true

class Deck


  attr_accessor :player_deck, :player_name
  def initialize
    @player_name = "Provisional"
    @deck_size = 15
    @player_deck = Hash.new
    populate_deck
    end


def populate_deck
  @deck_size.times do |i|
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

    hash_value = {card_id: random,
                  monster_card: is_monster,
                  monster_values: monster_content,
                  position: :deck}

    @player_deck[i] = hash_value
  end
end

  def initial_hand
    count = 0
    @player_deck.each do |key, value|
      if count < 5 && value[:position] != :hand
        value[:position] = :hand
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


  def card_details(card_id)
    # Fetch card details from Card and Monster models
    card = Card.find(card_id)
    monster = Monster.find_by(id: card.foreign_id) if card.cardtype == 1

    {
      name:
        case card.cardtype
        when 1
          Monster.where(id: card.foreign_id).pluck(:name).first
        when 2
          Consumable.where(id: card.foreign_id).pluck(:name).first
        when 3
          Equipable.where(id: card.foreign_id).pluck(:name).first
        else
          "Unknown name"


        end,
      type:
        case card.cardtype
        when 1
          "Monster"
        when 2
          "Consumable"
        when 3
          "Equipable"
        else
          "Unknown type"
        end,

      monster_hp: monster&.healthpoints || 'N/A',

      card_id: Card.where(id: card.id).pluck(:id).first.to_s
    }
    end



end
