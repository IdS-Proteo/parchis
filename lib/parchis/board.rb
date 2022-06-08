# TODO: When a player leave, and somehow the server tells you, update this model. Need to erase that player from @players, and possibly touch @player_turn among
# TODO: possibly other things.
# Parchis #Board.
class Board

  COLORS = [:red, :green, :blue, :yellow].freeze
  YELLOW_HOUSE_CELLS = 101..104
  YELLOW_HOUSE_EXIT_CELL = 5
  YELLOW_FINISH_CELL = 76
  YELLOW_FIRST_PRE_FINISH_CELLS = [68, 69]
  BLUE_HOUSE_CELLS = 105..108
  BLUE_HOUSE_EXIT_CELL = 22
  BLUE_FINISH_CELL = 84
  BLUE_FIRST_PRE_FINISH_CELLS = [17, 77]
  RED_HOUSE_CELLS = 109..112
  RED_HOUSE_EXIT_CELL = 39
  RED_FINISH_CELL = 92
  RED_FIRST_PRE_FINISH_CELLS = [34, 85]
  GREEN_HOUSE_CELLS = 113..116
  GREEN_HOUSE_EXIT_CELL = 56
  GREEN_FINISH_CELL = 100
  GREEN_FIRST_PRE_FINISH_CELLS = [51, 93]

  attr_reader :cells, :players, :player_turn

  # @param players [Array<Player>]
  # @param player_turn [Integer, nil] can't be out of the range of 0..(@players.length - 1)
  def initialize(players, player_turn: nil)
    initialize_cells()
    @players = players
    assign_color_to_players() if !@players.first.color
    # assign tokens to each player
    @tokens = []
    assign_tokens_to_players()
    # the player turn points to the index of @players, and it continues clockwise
    @player_turn = player_turn || (rand(1..players.length) - 1)
    # this player can already roll the dice
    @players[@player_turn].can_roll_dice = true
  end

  # Switches the turn to the next player.
  def next_turn
    # clean rights of current player
    @players[@player_turn].clear_rights()
    # switch turn
    if(@players[@player_turn + 1])
      @player_turn = @player_turn + 1
    else
      @player_turn = 0
    end
    # make the new player able to cast the dice
    @players[@player_turn].can_roll_dice = true
  end

  # @param result [Integer]
  # Dice rolled by current player in turn.
  def dice_rolled(result:)
    player = @players[@player_turn] #: Player
    case result
      when 5
        # try to get a token out of the house
        if(tokens_to_draw = tokens_to_draw_from_house(player: player)) #: Array<Token> or false
          # player must draw a token from its house
          player.enable_to_move(tokens_to_draw)
          player.activity = :taking_token_out_of_its_house
        else
          # can't draw a token from house but could move another token in play
          if(!(tokens_in_play_that_can_be_moved = tokens_in_play_that_can_be_moved(player: player, cells_to_travel: result)).empty?)
            player.enable_to_move(tokens_in_play_that_can_be_moved)
            player.activity = :moving_tokens_in_play
          else
            # can't move any single token
            # WIP: ...

          end
        end
      when 6

      else
        nil
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

  # @param player [Player]
  # @return [nil, Array<Token>]
  # Return nil if can't draw a token (either because the player doesn't have tokens in his house or if there's a barricade in the house's exit); or an array of
  # tokens the player can draw.
  def tokens_to_draw_from_house(player:)
    # first check if there's at least one token in the player's house
    house_slots = Board.const_get("#{player.color.to_s.upcase}_HOUSE_CELLS".to_sym)
    tokens_to_draw = []
    player.tokens.each do |token|
      if(house_slots.include?(token.cell.id))
        tokens_to_draw << token
      end
    end
    if(!tokens_to_draw.empty? && !@cells[Board.const_get("#{player.color.to_s.upcase}_HOUSE_EXIT_CELL".to_sym)].barricade?)
      tokens_to_draw
    else
      nil
    end
  end

  # @param player [Player]
  # @param cells_to_travel [Integer] what the dice rolled this turn
  # @return [Array<Token>] could return an empty array
  def tokens_in_play_that_can_be_moved(player:, cells_to_travel:)
    upcased_player_color = player.color.to_s.upcase
    house_slots = Board.const_get("#{upcased_player_color}_HOUSE_CELLS".to_sym) #: Range<Integer>
    finish_slot = Board.const_get("#{upcased_player_color}_FINISH_CELL".to_sym) #: Integer
    tokens_in_play_that_can_be_moved = []
    player.tokens.each do |token|
      # see if this token is in play
      if((cell_id = token.cell.id) != finish_slot && !house_slots.include?(cell_id))
        # is in play, but can be moved? If in the middle there's a barricade, can't move
        can_do_it = true
        cells_to_travel.times do |step|
          future_cell_id, going_backwards = get_next_player_cell_id(player: player, cell_id: future_cell_id || cell_id, going_backwards: going_backwards || false)
          if(cell_id != future_cell_id && future_cell_id != finish_slot && @cells[future_cell_id].barricade?)
            can_do_it = false
            break
          end
        end
        tokens_in_play_that_can_be_moved << token if can_do_it
      end
    end
    tokens_in_play_that_can_be_moved
  end

  # @param player [Player]
  # @param cell_id [Integer] "current" cell id
  # @param going_backwards [Boolean] pass true if the token is going backwards
  # @return [Array(Integer, Boolean)] first item is next cell id, second item is if the token is going backwards
  # Don't call this for cells inside a house nor for cells in some finish cell. This is only for cells into play.
  def get_next_player_cell_id(player:, cell_id:, going_backwards: false)
    pre_finish_cells = Board.const_get("#{player.color.to_s.upcase}_FIRST_PRE_FINISH_CELLS".to_sym) #: Array(Integer, Integer)
    finish_slot = Board.const_get("#{upcased_player_color}_FINISH_CELL".to_sym) #: Integer
    if(cell_id == pre_finish_cells.first)
      [pre_finish_cells.last, false]
    elsif(cell_id == finish_slot || going_backwards)
      [cell_id - 1, true]
    else
      [cell_id + 1, false]
    end
  end
end
