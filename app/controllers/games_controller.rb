# frozen_string_literal: true

class GamesController < ApplicationController


  def deck
    @deck = Deck.new
    @deck.initial_hand
    @player_deck = @deck.player_deck
  end

  def initialize_monster
    @deck = Deck.new
    chosen_monster_id = params[:monster_id].to_i
    @deck.initialize_monster(chosen_monster_id)
    @player_deck = @deck.player_deck
    redirect_to game_deck_path  # Redirect or render as needed
  end
  def board
    @monid1 = params[:mon1]
    @monid2 = params[:mon2]
  end

  def hand

  end



end
