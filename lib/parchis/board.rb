# TODO: When a player leave, and somehow the server tells you, update this model. Need to erase that player from @players, and possibly touch @player_turn among
# TODO: possibly other things.
# Parchis #Board.
class Board

  COLORS = [:red, :green, :blue, :yellow].freeze
  YELLOW_HOUSE_CELLS = 101..104
  BLUE_HOUSE_CELLS = 105..108
  RED_HOUSE_CELLS = 109..112
  GREEN_HOUSE_CELLS = 113..116

  attr_reader :cells, :players

  # @param players [Array<Player>]
  def initialize(players)
    initialize_cells()
    @players = players
    assign_color_to_players()
    # assign tokens to each player
    @tokens = []
    assign_tokens_to_players()
    # the player turn points to the index of @players, and it continues clockwise
=begin
    @player_turn = rand(1..players.length) - 1
=end
    # ATTENTION: Uncomment previous line after debugging, now forcing first player
    @player_turn = 0
    # ATTENTION: Uncomment previous line after debugging, now forcing first player
    # this player can already roll the dice
    @players[@player_turn].can_roll_dice = true
  end

  # Switches the turn to the next player.
  def next_turn
    if(@players[@player_turn + 1])
      @player_turn = @player_turn + 1
    else
      @player_turn = 0
    end
  end

  # @return [Player]
  # Returns the #Player that owns the current turn.
  def player_turn
    @players[@player_turn]
  end

  # ATTENTION: Debugging purpose method.
  # @param tokens_amount [Symbol] :max or :min.
  def debug_tokens_positioning(tokens_amount:)
    @cells.each_with_index do |cell, index|
      next if index == 0
      next if Cell::FINISH_CELLS.include?(index)
      if(cell.empty?)
        if(tokens_amount == :max)
          @tokens << Token.new(:green, cell, 'T')
          @tokens << Token.new(:green, cell, 'T')
        else
          @tokens << Token.new(:green, cell, 'T')
        end
      end
    end
    Cell::FINISH_CELLS.each do |cell_id|
      if(tokens_amount == :max)
        @tokens << Token.new(:green, @cells[cell_id], 'T')
        @tokens << Token.new(:green, @cells[cell_id], 'T')
        @tokens << Token.new(:green, @cells[cell_id], 'T')
        @tokens << Token.new(:green, @cells[cell_id], 'T')
      else
        @tokens << Token.new(:green, @cells[cell_id], 'T')
      end
    end
  end

  private

  def assign_tokens_to_players
    @players.each do |player|
      label = '@'
      Board.const_get("#{player.color.to_s.upcase}_HOUSE_CELLS".to_sym).each do |i|
        @tokens << Token.new(player.color, @cells[i], label.next!.dup)
      end
      player.tokens = @tokens[-4..-1]
    end
  end

  # Initializes each cell (@cells).
  def initialize_cells
    @cells = []
    Cell::COORDS.size.times {|i| @cells << Cell.new(i)}
  end

  # Assign color to each player from @players. This is done randomly.
  def assign_color_to_players
    colors_not_picked = COLORS.dup
    @players.each {|player| player.color = colors_not_picked.delete(colors_not_picked.sample)}
  end
end
