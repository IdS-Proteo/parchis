# Parchis #Board.
class Board

  COLORS = [:red, :blue, :yellow, :green].freeze
  FINISH_CELLS = [76, 84, 92, 100].freeze
  SAFE_CELLS = [5, 12, 17, 22, 29, 34, 39, 46, 51, 56, 63, 68].freeze
  YELLOW_HOUSE_CELLS = 101..104
  YELLOW_HOUSE_EXIT_CELL = 5
  YELLOW_FINISH_CELL = 76
  YELLOW_FIRST_PRE_FINISH_CELLS = [68, 69].freeze
  BLUE_HOUSE_CELLS = 105..108
  BLUE_HOUSE_EXIT_CELL = 22
  BLUE_FINISH_CELL = 84
  BLUE_FIRST_PRE_FINISH_CELLS = [17, 77].freeze
  RED_HOUSE_CELLS = 109..112
  RED_HOUSE_EXIT_CELL = 39
  RED_FINISH_CELL = 92
  RED_FIRST_PRE_FINISH_CELLS = [34, 85].freeze
  GREEN_HOUSE_CELLS = 113..116
  GREEN_HOUSE_EXIT_CELL = 56
  GREEN_FINISH_CELL = 100
  GREEN_FIRST_PRE_FINISH_CELLS = [51, 93].freeze


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
    # subscribers (strategy pattern)
    @next_turn_subscribers = []
    @dice_rolled_subscribers = []
    @perform_move_subscribers = []
  end

  # @return [Boolean] true if all went good, false otherwise. False means that you've been left alone in the match.
  # Switches the turn to the next player.
  def next_turn
    # clean rights of current player (if exist)
    @players[@player_turn].clear_rights() if @players[@player_turn]
    # seek next player that should receive turn
    if(@player_turn == (@players.length - 1))
      # last player in the array, seek a new one from the beginning
      0.upto(@players.length - 1) do |index|
        if(@players[index])
          if(@player_turn != index)
            @player_turn = index
            break
          else
            # you are the only player in the match
            return false
          end
        end
      end
    else
      index_forward_found = false
      (@player_turn + 1).upto(@players.length - 1) do |index|
        if(@players[index])
          @player_turn = index
          index_forward_found = true
          break
        end
      end
      if(!index_forward_found)
        0.upto(@players.length - 1) do |index|
          if(@players[index])
            if(@player_turn != index)
              @player_turn = index
            else
              # you are the only player in the match
              return false
            end
          end
        end
      end
    end
    # make the new player able to cast the dice
    @players[@player_turn].can_roll_dice = true
    # alert subscribers
    @next_turn_subscribers.each {|s| s.update()}
    true
  end

  # @param result [Integer]
  # @return [Symbol] player activity due to this dice cast.
  # Dice rolled by current player in turn.
  def dice_rolled(result:)
    player = @players[@player_turn] #: Player
    player.add_roll(result)
    case result
      when 5
        # try to get a token out of the house
        if(tokens_to_draw = tokens_to_draw_from_house(player: player)) #: Array<Token> or nil
          # player must draw a token from its house
          player.enable_to_move(tokens_to_draw)
          player.activity = :taking_token_out_of_its_house
        else
          check_possible_regular_moves(player, result)
        end
      when 6
        if(!(tokens_in_barriers = tokens_in_barriers_that_can_be_moved(player: player, cells_to_travel: result)).empty?)
          # this player has at least 1 barrier
          player.enable_to_move(tokens_in_barriers)
          player.activity = :moving_token_out_of_barrier
        else
          check_possible_regular_moves(player, result)
        end
      else
        check_possible_regular_moves(player, result)
    end
    # alert subscribers
    @dice_rolled_subscribers.each {|s| s.update()}
    player.activity
  end

=begin
  @param token_label [String]
  @param cells_to_move [Integer]
  @param player [Player]
  It is supposed, that previously, it was checked that this move is possible, so this method doesn't perform extra checks.
  Possible use cases:
    * use case 1: this token achieved the goal
    * use case 2: the cell is empty, no need to check anything else
    * use case 3: arriving to a safe cell
      * use case 3.1: 2 existent tokens living here, and they aren't a barrier (hence, 2 different color tokens), last token there gets "eaten"
      * use case 3.2: lone token here, just check if it's of the player's color, in which case, a barrier gets created
    * use case 4: arriving to a non safe cell
      * use case 4.1: non-empty cell; same color token; a barrier will get formed
      * use case 4.2: non-empty cell; different color token; existent token is going to be "eaten"
=end
  def perform_move(token_label:, cells_to_move:, player:)
    # check if this is the special move of getting out a token from its house
    if(player.activity == :taking_token_out_of_its_house)
      # put this *token* in its house exit
      cell = @cells[Board.const_get("#{player.color.to_s.upcase}_HOUSE_EXIT_CELL".to_sym)]
      eaten_token = cell.place_token(player[token_label])
    else
      # inquire what is the target cell id
      cell_id = (token = player[token_label]).cell.id #: Integer
      cells_to_move.times {cell_id, going_backwards = get_next_player_cell_id(player: player, cell_id: cell_id, going_backwards: (going_backwards || false))}
      # perform the actual move
      cell = @cells[cell_id]
      eaten_token = cell.place_token(token) #: nil or Token
    end
    # check if a token was eaten
    if(eaten_token)
      send_token_to_its_house(eaten_token)
      # note this in the player (for stats)
      player.tokens_eaten += 1
    end
    # check if a barrier were formed
    if(cell.barrier?)
      player.barriers_generated += 1
    end
    # updates moves on player (for stats)
    player.cells_advanced += (player.activity == :taking_token_out_of_its_house ? 1 : cells_to_move)
    # activity completed
    player.activity = nil
    # alert subscribers
    @perform_move_subscribers.each {|s| s.update()}
  end

  # @param player_id [Integer]
  # @return [Boolean] false if you're the only player left
  # Removes all his tokens from the board, among other things.
  def player_quitted(player_id:)
    player = @players[player_id]
    return(false) if !player
    player.tokens.each do |token|
      token.cell.remove_token(token: token)
    end
    @players[player_id] = nil
    if(@player_turn == player_id)
      return next_turn()
    end
    true
  end

  # @param subscriber [Object] object passed must have update() implemented
  def add_subscribers_to_next_turn(*subscriber)
    @next_turn_subscribers.concat(subscriber)
  end

  # @param subscriber [Object] object passed must have update() implemented
  def add_subscribers_to_dice_rolled(*subscriber)
    @dice_rolled_subscribers.concat(subscriber)
  end

  # @param subscriber [Object] object passed must have update() implemented
  def add_subscribers_to_perform_move(*subscriber)
    @perform_move_subscribers.concat(subscriber)
  end

  private

  def assign_tokens_to_players
    @players.each do |player|
      label = '@'
      Board.const_get("#{player.color.to_s.upcase}_HOUSE_CELLS".to_sym).each do |i|
        @tokens << (token = Token.new(player.color, label.next!.dup))
        # register this token on the right cell
        @cells[i].place_token(token)
      end
      player.tokens = @tokens[-4..-1]
    end
  end

  # Initializes each cell (@cells).
  def initialize_cells
    @cells = []
    Cell::COORDS.size.times {|i| @cells << Cell.new(i)}
  end

  # Assign color to each player from @players. This is done randomly but clockwise.
  def assign_color_to_players
    color_id = rand(0..(COLORS.size - 1))
    player_id_with_first_color = rand(0..(@players.size - 1))
    @players[player_id_with_first_color].color = COLORS[color_id]
    next_player_id = @players[player_id_with_first_color + 1] ? player_id_with_first_color + 1 : 0
    while(!@players[next_player_id].color)
      color_id = COLORS[color_id + 1] ? color_id + 1 : 0
      @players[next_player_id].color = COLORS[color_id]
      # next player
      next_player_id = @players[next_player_id + 1] ? next_player_id + 1 : 0
    end
  end

  # @param player [Player]
  # @return [nil, Array<Token>]
  # Return nil if can't draw a token (either because the player doesn't have tokens in his house or if there's a barrier in the house's exit); or an array of
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
    if(!tokens_to_draw.empty? && !@cells[Board.const_get("#{player.color.to_s.upcase}_HOUSE_EXIT_CELL".to_sym)].barrier?)
      tokens_to_draw
    else
      nil
    end
  end

  # @param player [Player]
  # @param cells_to_travel [Integer] what the dice rolled this turn
  # @param tokens [nil, Array<Token>] you could pass the exact tokens to check. nil would check all of them
  # @return [Array<Token>] could return an empty array
  def tokens_in_play_that_can_be_moved(player:, cells_to_travel:, tokens: nil)
    upcased_player_color = player.color.to_s.upcase #: String
    house_slots = Board.const_get("#{upcased_player_color}_HOUSE_CELLS".to_sym) #: Range<Integer>
    finish_slot = Board.const_get("#{upcased_player_color}_FINISH_CELL".to_sym) #: Integer
    tokens_in_play_that_can_be_moved = []
    (tokens || player.tokens).each do |token|
      # see if this token is in play
      if((cell_id = token.cell.id) != finish_slot && !house_slots.include?(cell_id))
        # is in play, but can be moved? If in the middle there's a barrier, can't move
        can_do_it = true
        future_cell_id = nil
        going_backwards = nil
        cells_to_travel.times do
          future_cell_id, going_backwards = get_next_player_cell_id(player: player, cell_id: future_cell_id || cell_id, going_backwards: going_backwards || false)
          if((cell_id != future_cell_id) && (future_cell_id != finish_slot) && (@cells[future_cell_id].barrier?))
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
    upcased_player_color = player.color.to_s.upcase
    pre_finish_cells = Board.const_get("#{upcased_player_color}_FIRST_PRE_FINISH_CELLS".to_sym) #: Array(Integer, Integer)
    finish_slot = Board.const_get("#{upcased_player_color}_FINISH_CELL".to_sym) #: Integer
    if(cell_id == pre_finish_cells.first)
      [pre_finish_cells.last, false]
    elsif((cell_id == finish_slot) || going_backwards)
      [cell_id - 1, true]
    else
      [cell_id + 1, false]
    end
  end

  # @param player [Player]
  # @param cells_to_travel [Integer] what the dice rolled this turn
  # @return [Array<Token>] could return an empty array
  def tokens_in_barriers_that_can_be_moved(player:, cells_to_travel:)
    potential_tokens_in_barriers_that_could_be_moved = []
    # collect tokens in barriers
    player.tokens.each {|token| potential_tokens_in_barriers_that_could_be_moved << token if token.cell.barrier?}
    # see if they can actually be moved
    if(!potential_tokens_in_barriers_that_could_be_moved.empty?)
      tokens_in_play_that_can_be_moved(player: player, cells_to_travel: cells_to_travel, tokens: potential_tokens_in_barriers_that_could_be_moved)
    else
      []
    end
  end

  # @param player [Player]
  # @param result [Integer]
  # @return [Symbol] the current player activity according to dice cast
  def check_possible_regular_moves(player, result)
    if(!(tokens_in_play_that_can_be_moved = tokens_in_play_that_can_be_moved(player: player, cells_to_travel: result)).empty?)
      # can't draw a token from house but could move another token in play
      player.enable_to_move(tokens_in_play_that_can_be_moved)
      player.activity = :moving_tokens_in_play
    else
      # can't move any single token
      player.activity = :cant_do_anything
    end
  end

  # @param token [Token]
  def send_token_to_its_house(token:)
    Board.const_get("#{token.color.to_s.upcase}_HOUSE_CELLS".to_sym).each do |house_cell_id|
      if(@cells[house_cell_id].empty?)
        @cells[house_cell_id].place_token(token)
        return
      end
    end
  end
end
