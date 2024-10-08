class Game
  attr_accessor :player1, :player2, :turn_number, :player1_turn

  def initialize
    @player1 = Deck.new
    @player2 = Deck.new
    @turn_number = 0
    @passive_effects = []
    @player1_turn = [true, false].sample  # Randomly decide who goes first
  end

  def coin_toss
    [:heads, :tails].sample
  end


  def begin_turn
    if turn_number < 2

      if @player1_turn
        player1.initial_hand
      else
        player2.initial_hand
      end

    else

      if @player1_turn
        player1.draw_card
      else
        player2.draw_card
      end

    end
    end

  def end_turn
    if @player1_turn && @turn_number > 1
    @player1.decrease_cooldowns
    else
      @player2.decrease_cooldowns
    end

    @player1_turn = !@player1_turn
    @turn_number += 1

  end

  def current_player
    @player1_turn ? @player1 : @player2
  end

  def opponent_player
    @player1_turn ? @player2 : @player1
  end

  # Example method to simulate a turn-based action
  def perform_action(action, *args)
    if @player1_turn
      puts "Player 1's turn"
      # Perform the action on player1
      send(action, @player1, *args)
    else
      puts "Player 2's turn"
      # Perform the action on player2
      send(action, @player2, *args)
    end

    end_turn
  end


end

