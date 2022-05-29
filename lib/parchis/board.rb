class Board

  attr_reader :cells

  # @param players [Array<Player>]
  def initialize(players)
    initialize_cells()
    # assign tokens to each player
    @tokens = []
    players.each do |player|
      label = '@'
      case player.color
        when :yellow
          (101..104).each {|i| @tokens << Token.new(player.color, @cells[i], label.next!.dup)}
        when :blue
          (105..108).each {|i| @tokens << Token.new(player.color, @cells[i], label.next!.dup)}
        when :red
          (109..112).each {|i| @tokens << Token.new(player.color, @cells[i], label.next!.dup)}
        when :green
          (113..116).each {|i| @tokens << Token.new(player.color, @cells[i], label.next!.dup)}
      end
      player.tokens = @tokens[-4..-1]
    end
  end

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

  # Initializes each cell (@cells).
  def initialize_cells
    @cells = []
    Cell::COORDS.size.times do |i|
      @cells << Cell.new(i)
    end
  end
end
