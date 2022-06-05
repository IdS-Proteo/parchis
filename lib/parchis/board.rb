# Parchis #Board.
class Board

  COLORS = [:red, :green, :blue, :yellow].freeze
  YELLOW_HOUSE_CELLS = 101..104
  BLUE_HOUSE_CELLS = 105..108
  RED_HOUSE_CELLS = 109..112
  GREEN_HOUSE_CELLS = 113..116

  attr_reader :cells

  # @param players [Array<Player>]
  def initialize(players)
    initialize_cells()
    @players = players
    assign_color_to_players()
    # assign tokens to each player
    @tokens = []
    assign_tokens_to_players()
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
