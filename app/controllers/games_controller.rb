# frozen_string_literal: true

class GamesController < ApplicationController

    def deck

      player_deck_record = PlayerDeck.find_or_create_by(user: Current.user)

      if player_deck_record.deck_data.present?
        @deck = Deck.new
        @deck.player_deck = player_deck_record.deck_data
      else
        @deck = Deck.new
        @deck.initial_hand
        player_deck_record.update(deck_data: @deck.player_deck)
      end


      @arrayed_deck = @deck.player_deck.map do |key, card|
        next if card[:card_id].nil? # Skip if card_id is nil
        card_details = @deck.card_details(card[:card_id])
        {
          position: card[:position],
          name: card_details[:name],
          type: card_details[:type],
          monster_hp: card_details[:monster_hp],
          card_id: card_details[:card_id]
        }
      end
    end




  def initialize_monster
    @deck = Deck.new
    chosen_monster_id = params[:monster_id].to_i
    @deck.initialize_monster(chosen_monster_id)
    @player_deck = @deck.player_deck
    redirect_to game_deck_path  # Redirect or render as needed
  end

    def force_refresh_deck
      @deck = Deck.new
      @deck.initial_hand
      player_deck_record.update(deck_data: @deck.player_deck)
    end
  def board
    @monid1 = params[:mon1]
    @monid2 = params[:mon2]
  end

  def hand

  end



end
