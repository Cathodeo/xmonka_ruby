# frozen_string_literal: true

class Deck


  attr_accessor :player_deck, :player_name, :monsters_defeat
  def initialize
    #Initialize an empty deck and populate it
    @player_name = "Provisional"
    @deck_size = 16
    @player_deck = Hash.new
    @monsters_defeat = 3
    @current_ingame_key = self.which_monkey
    @current_ingame_id = self.which_monid
    populate_deck
    puts("Initialized Deck")
    end



  #Turn 1 logic to choose first in game monster.
  # (Todo: Safeguards for cases where no Monster card is in hand)
def populate_deck

  # Beginning the game flow generating a 'Random deck', the random-ness will be
  # more fine tuned as the deck is completed, for balance purposes.

  @deck_size.times do |i|
    random = rand(1..28)
    monster_content = {}
    is_monster = false
    if Card.where(id: random).pluck(:cardtype).first == 1
      monster_content = {
        current_hp: Monster.where(id: Card.where(id: random).pluck(:foreign_id)).pluck(:healthpoints).first,
        status_id: 0,
        equipped_id: 0,
        cooldown: Monster.where(id: Card.where(id: random).pluck(:foreign_id)).pluck(:cooldown).first
      }
      is_monster = true
    end

    hash_value = {card_id: random,
                  monster_card: is_monster,
                  monster_values: monster_content,
                  position: :deck}

    @player_deck[i] = hash_value
    puts("Populated deck of #{@deck_size} cards for player #{@player_name}")
  end
end

  def initial_hand
    #A hand of five cards as the first available one
    #Special cards that allow retrieving a new full hand
    # might reuse this method
    count = 0
    @player_deck.each do |key, value|
      if count < 5 && value[:position] != :hand
        value[:position] = :hand
        count += 1
      end
    end
    puts("Populated initial hand of five cards")
  end


  def draw_card
    # Iterate over the player_deck to find the first card not in the hand
    @player_deck.each do |key, value|
      if value[:position] != :hand
        value[:position] = :hand
        puts "Drew card with key: #{key}"
        return key  # Return the card key to confirm the card drawn
      end
    end
    puts "No cards available to draw."
    nil  # Return nil if no cards were available to draw
  end



  def initialize_monster(monster_key)
    # This method checks against global card type and not the 'Key'
    # This means the first occurrence of any monster chosen of the same type will be
    # initialized.
    # Check if any card is already in the :gamearea
    any_in_gamearea = @player_deck.any? { |_key, subhash| subhash[:position] == :gamearea }

    # Iterate through the player deck and update the position of the chosen monster
    @player_deck.each do |key, subhash|
      if key == monster_key
        if any_in_gamearea
          subhash[:position] = :bench
        else
          subhash[:position] = :gamearea
        end
        puts("Initialized card key #{key} of type #{subhash[:card_id]}")
        break  # Stop after finding and updating the first match
      end
    end

  end


  def switch_monsters(outgoing_key, incoming_key, debug)
    # Initialize variables to hold the keys of the valid cards
    outgoing_card = nil
    incoming_card = nil

    # Find the outgoing card and validate it
    @player_deck.each do |key, subhash|
      if key == outgoing_key && subhash[:position] == :gamearea && (subhash[:cooldown] == 0 || debug)
        puts "The outgoing card is valid"
        outgoing_card = key
        break
      end
    end

    # Find the incoming card and validate it
    @player_deck.each do |key, subhash|
      if key == incoming_key && subhash[:position] == :bench
        puts "Valid incoming card"
        incoming_card = key
      end
    end

    # Check if both cards are valid
    if outgoing_card.nil? || incoming_card.nil?
      puts "Invalid match of cards. Aborting"
    else
      puts "Switching card #{outgoing_card} with #{incoming_card}"

      # Perform the switch
      @player_deck[outgoing_card][:position] = :bench
      @player_deck[outgoing_card][:monster_values][:cooldown] =
        Monster.where(id: Card.where(id: [outgoing_card][:card_id]).pluck(:foreign_id)).pluck(:cooldown).first
      @player_deck[incoming_card][:position] = :gamearea
    end
  end

  def self.terminate_card(player, card_key)
    #Discard a card.
    # Consumables = Terminated upon consumption
    # Monsters = Terminated when HP = 0
    # Equipables = Terminated when the Monster they are assigned to is terminated
    # Special consumables might discard one or several handed cards
    @player_deck.each do |key, subhash|
      if key == card_key
        subhash[:position] = :discarded
        if subhash[:ismonster] == true
          player.monsters_defeat -=1
        end
      end

    end
  end

  def is_monster_ingame?
    @player_deck.any? { |_key, subhash| subhash[:position] == :gamearea }
  end

  def is_monster_benched?
    @player_deck.any?  { |_key, subhash| subhash[:position] == :bench }
  end

  def self.key_to_cardid(key_choice, player)
    result = player.player_deck.find { |key, subhash| key == key_choice }
    result ? result[1][:card_id] : nil
  end

  def which_monster_ingame
    if is_monster_ingame?
      # Find the key and subhash where conditions are met
      key, subhash = @player_deck.find do |key, subhash|
        subhash[:position] == :gamearea && subhash[:monster_card] == true
      end

      if key && subhash
        # Print the key of the found card
        puts "Card with key #{key}"

        # Fetch and return card details for the found card
        card_details(subhash[:card_id])
      else
        # No card found that meets the conditions
        puts "No card found in the game area!"
      end
    else
      puts "No cards in game!"
    end
  end

  def which_monid
    if is_monster_ingame?
      # Find the key and subhash where conditions are met
      key, subhash = @player_deck.find do |key, subhash|
        subhash[:position] == :gamearea && subhash[:monster_card] == true
      end

      if key && subhash
        # Print the key of the found card
        puts "Card with key #{key}"

        # Fetch and return card details for the found card
       subhash[:card_id]
      else
        # No card found that meets the conditions
        puts "No card found in the game area!"
      end
    else
      puts "No cards in game!"
    end
  end

  def which_monkey
    if is_monster_ingame?
      # Find the key and subhash where conditions are met
      key, subhash = @player_deck.find do |key, subhash|
        subhash[:position] == :gamearea && subhash[:monster_card] == true
      end

      if key && subhash
        # Print the key of the found card
        puts "Card with key #{key}"

        # Fetch and return card details for the found card
        key
      else
        # No card found that meets the conditions
        puts "No card found in the game area!"
      end
    else
      puts "No cards in game!"
    end
  end


  def monsters_in_bench
    if is_monster_benched?
      # Find all keys and subhashes where conditions are met
      benched_monsters = @player_deck.select do |key, subhash|
        subhash[:position] == :bench && subhash[:monster_card] == true
      end

      if benched_monsters.any?
        # Print details of each found card
        benched_monsters.each do |key, _|
          puts "Card with key #{key}"
        end

        # Return the hash of found cards
        benched_monsters
      else
        # No card found that meets the conditions
        puts "No monster cards in the benched position!"
        {}
      end
    else
      puts "No cards in game!"
      {}
    end
  end

  def self.status_by_key(chosen_key, player)
      player.player_deck.each do |key, subhash|
      if key == chosen_key
        monster_info = subhash[:monster_values]
      end
      status_returned = monster_info[:status]
      puts "Status: #{status_returned}"
    end
  end


  def self.damage_monster(chosen_key, damage, player)
  player.player_deck.each do |key, subhash|
    if key == chosen_key
      # Ensure the correct data is accessed
      monster_content = subhash[:monster_values]
      if monster_content
        current_hp = monster_content[:current_hp] || 0
        new_hp = current_hp - damage
        
        puts "Former healthpoints: #{current_hp}"
        puts "Received #{damage} of damage"
        puts "Result: #{new_hp} healthpoints after damage"


        monster_content[:current_hp] = new_hp

        if monster_content[:current_hp] < 1
          subhash[:position] = :discarded
          player.monsters_defeat -=1
          puts "Monster defeated! Card discarded."
        end
      else
        puts "No monster content found for key #{key}"
      end
    end
  end
end


  def self.alter_status(chosen_key, chosen_status, player)
  player.player_deck.each do |key, subhash|
    if key == chosen_key
      # Ensure the correct data is accessed
      monster_content = subhash[:monster_values]
      monster_content[:status_id] = chosen_status
    end
  end
  end

  def self.equip_to_monster(chosen_key, chosen_item_key, player)

    equip_id = 0

    player.player_deck.each do |key, subhash|
      if key == chosen_item_key
        cardid = subhash[:card_id]
        equip_id = Equipable.where(id: Card.where(id: cardid).pluck(:foreign_id).first).pluck(:id).first
      end
    end

    player.player_deck.each do |key, subhash|
      if key == chosen_key
        # Ensure the correct data is accessed
        monster_content = subhash[:monster_values]
        monster_content[:equipped_id] = equip_id
        puts "Equiped equipable card #{chosen_item_key}, which is the equipable with id #{equip_id}"
      end
    end
  end


  def decrease_cooldowns
    @player_deck.each do |key, subhash|
      if key == self.which_monkey
        subhash[:monster_values][:cooldown] -= 1
      end
    end
  end

  def self.game_over?(player1, player2)
    # Check if any item is still in the deck
    cards_left = player2.player_deck.any? { |_key, value| value[:position] == :deck }

    # Check if any monsters are left either in the game or on the bench
    monsters_left = player2.player_deck.any? do |_key, value|
      value[:ismonster] == true && (value[:position] == :gamearea || value[:position] == :bench)
    end

    win_condition = player1.monsters_defeat == 0

    !cards_left || !monsters_left || win_condition
    puts "Game over!"
  end


  ##Methods that serve only the view

  def eligible_monsters
    #Shows Monster type cards which are on the hand,
    #Allows to choose the first monster/s to initialize on turn 1
    eligible_list = @player_deck.select do |key, card_hash|
      card_hash[:monster_card] && card_hash[:position] == :hand
    end.keys
    if eligible_list.empty?
      puts("No eligible monsters in hand")
    else
      puts("The following monster cards are eligible: #{eligible_list}")
      end

  end


  def card_details(card_id)
    # Fetch card details from Card and Monster models
    # This version is only for debug purposes, since the player should
    # only ever see his hand
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
