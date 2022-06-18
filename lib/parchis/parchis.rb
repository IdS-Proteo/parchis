# TODO: Code end of turn due to timeout of the turn.
# TODO: Add delay (3 seconds is ok) between turn end and the next one.

require 'gosu'

=begin
The game could be in one of three phases:
  1. Start screen
  2. Lobby of a match
  3. Match
=end
class Parchis < Gosu::Window
  
  WIDTH = 1254
  HEIGHT = 705
  BORDERS = 11
  ASSETS_PATH = "#{File.dirname(File.dirname(File.dirname(__FILE__)))}/assets".freeze

  attr_reader :lobby_updater, :phase

  # Constructor.
  def initialize
    super(WIDTH, HEIGHT)
    initialize_view()
    # multi-item array where each subsequent item is a sub-phase of its parent at the left
    @phase = [1]
    # ATTENTION: Debugging purpose method called
=begin
    @hosting = true
    @match_id = '123456789'
    @players = [
      Player.new(name: 'Self', local: true, host: !!@hosting),
      Player.new(name: 'Foolano', local: false, host: false)
    ]
    initialize_phase_3()
=end
    # ATTENTION: Debugging purpose method called
  end

  # Called around 60 times per second. Update the model according to users interactions.
  def update
    case(@phase.first)
      when 1
        if(@phase[1] == :capturing_match_id)
          if(button_down?(Gosu::KB_ESCAPE))
            reset_to_phase_1()
          elsif(button_down?(Gosu::KB_RETURN) || button_down?(Gosu::KB_ENTER))
            possible_match_id = self.text_input.text
            # success could be false (if problem) or an Integer indicating player id assigned/reserved
            success, object = HTTPClient.get_match_lobby_existence(match_id: possible_match_id)
            # the match lobby could exists or not, be full, or could exist a problem, in which case, report the feedback/error
            success ? capture_name(match_id: possible_match_id, player_id: success) : enqueue_error(object)
          end
        elsif(@phase[1] == :capturing_name)
          if((button_down?(Gosu::KB_RETURN) || button_down?(Gosu::KB_ENTER)) && !self.text_input.text.empty?)
            # this is you (local: true)
            @players = []
            @players[@player_id] = Player.new(name: self.text_input.text, local: true, host: !!@hosting)
            # switch to phase 2
            initialize_phase_2()
          end
        else
          if(button_down?(Gosu::KB_C))
            # create game
            success, string = HTTPClient.get_new_match_id()
            if(success)
              @hosting = true
              capture_name(match_id: string, player_id: 0)
            else
              # report the error
              enqueue_error(string)
            end
          elsif(button_down?(Gosu::KB_U))
            # want to access existent game lobby
            @phase = [1, :capturing_match_id]
            # enable text buffer
            self.text_input = Gosu::TextInput.new()
          elsif(button_down?(Gosu::KB_ESCAPE))
            reset_to_phase_1()
          end
        end
      when 2
        if(button_down?(Gosu::KB_ESCAPE))
          @lobby_updater.leave_lobby()
          reset_to_phase_1()
        elsif(button_down?(Gosu::KB_I) && @players[@player_id].host)
          # try to initialize phase 3
          if(@players.compact.size >= 2)
            initialize_phase_3()
            return
          else
            enqueue_error('Participantes insuficientes.')
          end
        end
        # update the lobby
        if((response = @lobby_updater.update()) == false)
          # something went wrong, report error
          enqueue_error("No es posible actualizar el lobby, problema en el server.")
        elsif(response.first == :game_started)
          # game started by the host, switch to phase 3
          @players = response[1..-1]
          initialize_phase_3(started_by_other: true)
        else
          @players = response
        end
      when 3
        if(button_down?(Gosu::KB_ESCAPE) && (button_down?(Gosu::KB_LEFT_SHIFT) || button_down?(Gosu::KB_RIGHT_SHIFT)))
          # quit this match
          @game_state_updater.leave_game()
          reset_to_phase_1()
        elsif((player_in_turn = @players[@board.player_turn]).local?)
          # only in this case the player can interact
          if(player_in_turn.can_roll_dice?)
            # if can roll dice, then can't move tokens (yet)
            if(button_down?(Gosu::KB_SPACE))
              player_in_turn.can_roll_dice = false
              @rolling_dice_sfx.play()
              # as priority, send to the server the roll
              @game_state_updater.event_processed(event_id: HTTPClient.post_dice_rolled(match_id: @match_id, result: @dice.roll()))
              if(@board.dice_rolled(result: @dice.last_roll()) == :cant_do_anything && !judge_second_dice_cast(player_in_turn))
                # end of turn, the player can't do anything
                @game_state_updater.event_processed(event_id: HTTPClient.post_token_moved(match_id: @match_id, token_color: player_in_turn.color, token_label: 'Z', cells_to_move: 0, end_of_turn: true))
                @board.next_turn
                # delay the dice change of state to "?"
                # TODO: Fix later... this is not working
                t = Thread.new {sleep(GameStateUpdater::UPDATE_INTERVAL); @dice.set_unknown_state()}
                t.join
                return
              end
            end
          elsif(player_in_turn.activity != :cant_do_anything)
            if(player_in_turn.can_move_a? && button_down?(Gosu::KB_A))
              player_in_turn.clear_rights(reset_activity: false)
              end_of_turn = !judge_second_dice_cast(player_in_turn)
              @game_state_updater.event_processed(event_id: HTTPClient.post_token_moved(match_id: @match_id, token_color: player_in_turn.color, token_label: 'A', cells_to_move: @dice.last_roll, end_of_turn: end_of_turn))
              @board.perform_move(token_label: 'A', cells_to_move: @dice.last_roll, player: player_in_turn)
              if(end_of_turn)
                @board.next_turn
                @dice.set_unknown_state
              end
            elsif(player_in_turn.can_move_b? && button_down?(Gosu::KB_B))
              player_in_turn.clear_rights(reset_activity: false)
              end_of_turn = !judge_second_dice_cast(player_in_turn)
              @game_state_updater.event_processed(event_id: HTTPClient.post_token_moved(match_id: @match_id, token_color: player_in_turn.color, token_label: 'A', cells_to_move: @dice.last_roll, end_of_turn: end_of_turn))
              @board.perform_move(token_label: 'B', cells_to_move: @dice.last_roll, player: player_in_turn)
              if(end_of_turn)
                @board.next_turn
                @dice.set_unknown_state
              end
            elsif(player_in_turn.can_move_c? && button_down?(Gosu::KB_C))
              player_in_turn.clear_rights(reset_activity: false)
              end_of_turn = !judge_second_dice_cast(player_in_turn)
              @game_state_updater.event_processed(event_id: HTTPClient.post_token_moved(match_id: @match_id, token_color: player_in_turn.color, token_label: 'A', cells_to_move: @dice.last_roll, end_of_turn: end_of_turn))
              @board.perform_move(token_label: 'C', cells_to_move: @dice.last_roll, player: player_in_turn)
              if(end_of_turn)
                @board.next_turn
                @dice.set_unknown_state
              end
            elsif(player_in_turn.can_move_d? && button_down?(Gosu::KB_D))
              player_in_turn.clear_rights(reset_activity: false)
              end_of_turn = !judge_second_dice_cast(player_in_turn)
              @game_state_updater.event_processed(event_id: HTTPClient.post_token_moved(match_id: @match_id, token_color: player_in_turn.color, token_label: 'A', cells_to_move: @dice.last_roll, end_of_turn: end_of_turn))
              @board.perform_move(token_label: 'D', cells_to_move: @dice.last_roll, player: player_in_turn)
              if(end_of_turn)
                @board.next_turn
                @dice.set_unknown_state
              end
            end
          end
        end
        # update the game state
        if(!@game_state_updater.update) then(enqueue_error("No es posible actualizar el estado del juego")) else @errors = [] end
        # update widgets
        @v_tips.update()
    end
  rescue StandardError, SystemExit
    if(@phase.first == 2) then @lobby_updater.leave_lobby() end
  end

  # Called 60 times per second. Draws the graphics.
  def draw
    self.method("draw_phase_#{@phase.first}".to_sym).call()
  end

  private

  # @param possible_match_id [String]
  # @param player_id [Integer], 0..X
  # Sets the @match_id and establish the "capture name" subphase.
  def capture_name(match_id:, player_id:)
    @match_id = match_id
    @player_id = player_id
    # go to capture name sub-phase
    @phase = [1, :capturing_name]
    # enable text buffer
    self.text_input = Gosu::TextInput.new()
  end

  # Initializes the view.
  def initialize_view
    # set window title
    self.caption = "Parchís"

    # errors holder. Depending on the phase, these are shown in different places
    @errors = []

    # load assets, phases background. Each #Array index matches phase number
    @phases_v = [nil]
    Dir["#{ASSETS_PATH}/img/phases/*.png"].sort.each {|bin| @phases_v << Gosu::Image.new(bin)}
    # tokens
    @tokens_v = {red: Gosu::Image.new("#{ASSETS_PATH}/img/tokens/red_token.png"),
                 blue: Gosu::Image.new("#{ASSETS_PATH}/img/tokens/blue_token.png"),
                 yellow: Gosu::Image.new("#{ASSETS_PATH}/img/tokens/yellow_token.png"),
                 green: Gosu::Image.new("#{ASSETS_PATH}/img/tokens/green_token.png")}
    # dice faces. On the index 0 is the "?", for the rest, index match with proper dice face
    @dices_v = []
    Dir["#{ASSETS_PATH}/img/dices/dice_*.png"].sort.each {|bin| @dices_v << Gosu::Image.new(bin)}

    # common font
    @font_v = Gosu::Font.new(16)
    @font_big_v = Gosu::Font.new(32)

    # samples
    @rolling_dice_sfx = Gosu::Sample.new("#{ASSETS_PATH}/samples/rolling_dice.ogg")
  end

  # @param error_message [String]
  def enqueue_error(error_message)
    @errors << error_message if !@errors.include?(error_message)
  end

  # @param player_in_turn [Player]
  # @return [Boolean] true if can do a second cast, false if this should be the turn's end
  def judge_second_dice_cast(player_in_turn)
    if(!@dice.cant_roll_anymore_for_current_player)
      player_in_turn.clear_rights
      player_in_turn.can_roll_dice = true
    else
      false
    end
  end

  # Phase 1.
  def draw_phase_1
    @phases_v[1].draw(0, 0, 0)
    # label related to input widgets according to subphase
    if(@phase[1] == :capturing_match_id)
      @font_v.draw_text("Ingresa el Match ID y presiona [Enter]: ", 50, 400, 1)
    elsif(@phase[1] == :capturing_name)
      @font_v.draw_text("Ingresa tu nombre y presiona [Enter]: ", 50, 400, 1)
    end
    # input widget may go or not
    @font_v.draw_text(self.text_input.text, 50, 425, 1) if @phase[1]
    # draw any error if exist
    @font_v.draw_text("ERROR: #{@errors.join('. ')}", 50, 450, 1, 1, 1, 0xff_ff0000) if !@errors.empty?
  end

  # Resets the Phase 1.
  def reset_to_phase_1
    # unnatach text input to the window
    self.text_input = nil
    # clean error messages
    @errors = []
    # clean other variables
    @match_id = nil; @players = nil; @hosting = nil
    # back to phase 1 start
    @phase = [1]
  end

  # Initializes phase 2.
  def initialize_phase_2
    # unnatach text buffer from window
    self.text_input = nil
    @lobby_updater = LobbyUpdater.new(players: @players, match_id: @match_id, player_id: @player_id)
    @lobby_updater.join_lobby()
    # clean error messages
    @errors = []
    # go to phase 2
    @phase = [2]
  end

  # Phase 2.
  def draw_phase_2
    @phases_v[2].draw(0, 0, 0)
    # match id
    @font_v.draw_text(@match_id, 110, 160, 1)
    # players
    @players.compact.each_with_index {|player, index| @font_v.draw_text(player.name, 50, 250 + (index * 25), 1, 1, 1, player.host ? 0xff_0000ff : 0xff_00ff00)}
    # draw any error if exist
    @font_v.draw_text("ERROR: #{@errors.join('. ')}", 50, 595, 1, 1, 1, 0xff_ff0000) if !@errors.empty?
  end

  # Initializes phase 3.
  def initialize_phase_3(started_by_other: false)
    @dice = Dice.new()
    # clean error messages
    @errors = []
    # clean @players of empty slots generated by player entering and leaving the lobby
    @players.compact!
    @player_id = @players.each_with_index {|player, index| if player.local? == true then index end}
    if(started_by_other)
      @board = Board.new(@players, player_turn: HTTPClient.get_player_turn(match_id: @match_id))
    else
      @board = Board.new(@players)
      # push this data to the server
      HTTPClient.post_match_started(match_id: @match_id, colors: @players.map {|player| player.color}, player_turn: @board.player_turn)
    end
    # initialize game updater
    @game_state_updater = GameStateUpdater.new(match_id: @match_id, player_id: @player_id, board: @board, dice: @dice, players: @players, rolling_dice_sfx: @rolling_dice_sfx)
    # widgets
    @v_countdown = VCountdown.new(font: @font_big_v)
    @v_actions = VActions.new(font: @font_v)
    @v_stats = VStats.new(font: @font_v)
    @v_tips = VTips.new(font: @font_v)
    @v_current_turn = VCurrentTurn.new(board: @board, font: @font_big_v)
    # switch to phase 3
    @phase = [3]
  end

  # Phase 3.
  def draw_phase_3
    # draw board
    @phases_v[3].draw(0, 0, 0)
    draw_cells_content()
    # dice
    @dices_v[@dice.last_roll].draw(HEIGHT, BORDERS, 1)
    # widgets
    @v_countdown.draw()
    @v_actions.draw()
    @v_stats.draw()
    @v_tips.draw()
    @v_current_turn.draw()
    # draw any error if exist
    @font_v.draw_text("ERROR: #{@errors.join('. ')}", VCurrentTurn::X_POS, 595, 1, 1, 1, 0xff_ff0000) if !@errors.empty?
  end

  def draw_cells_content
    @board.cells.each_with_index do |cell, index|
      tokens = cell.tokens #: Array<Token>
      if (Board::FINISH_CELLS.include?(index))
        case tokens.size
          when 1
            # position 2 is occupied
            draw_token(token: tokens.first, coords: cell.coords_mid)
          when 2
            # positions 1 & 2 are occupied
            draw_token(token: tokens.first, coords: cell.coords_bottom)
            draw_token(token: tokens.last, coords: cell.coords_mid)
          when 3
            # positions 1 & 2 & 3 are occupied
            draw_token(token: tokens.first, coords: cell.coords_bottom)
            draw_token(token: tokens[1], coords: cell.coords_mid)
            draw_token(token: tokens.last, coords: cell.coords_top)
          when 4
            # positions 1 & 2 & 3 & 4 are occupied
            draw_token(token: tokens.first, coords: cell.coords_bottom)
            draw_token(token: tokens[1], coords: cell.coords_mid)
            draw_token(token: tokens[2], coords: cell.coords_top)
            draw_token(token: tokens.last, coords: cell.coords_aux)
        end
      elsif (tokens.size == 1)
        # mid positioning
        draw_token(token: tokens.first, coords: cell.coords_mid)
      elsif (tokens.size == 2)
        # top and bottom posittioning
        draw_token(token: tokens.first, coords: cell.coords_top)
        draw_token(token: tokens.last, coords: cell.coords_bottom)
      end
    end
  end

  # @param token [Token]
  # @param coords [Hash<Symbol => Integer>]
  def draw_token(token:, coords:)
    @tokens_v[token.color].draw(coords[:x], coords[:y], 1)
    # draw its label, i.e.: "A", "B", ...
    @font_v.draw_text(token.label, coords[:x] + 7, coords[:y] + 5, 2, 1, 1, 0xff_000000)
  rescue
    p token
    p coords
  end
end
