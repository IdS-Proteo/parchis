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

  # Constructor.
  def initialize
    super(WIDTH, HEIGHT)
    initialize_view()
    # multi-item array where each subsequent item is a sub-phase of its parent at the left
    @phase = [1]
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
            success, object = HTTPClient.get_match_lobby_existence(match_id: possible_match_id)
            # the match lobby could exists or not, be full, or could exist a problem, in which case, report the feedback/error
            success ? capture_name(match_id: possible_match_id) : enqueue_error(object)
          end
        elsif(@phase[1] == :capturing_name)
          if(button_down?(Gosu::KB_ESCAPE))
            reset_to_phase_1()
          elsif((button_down?(Gosu::KB_RETURN) || button_down?(Gosu::KB_ENTER)) && !self.text_input.text.empty?)
            # this is you (local: true), @players[0] is always you (this client)
            @players = [Player.new(name: self.text_input.text, local: true, host: !!@hosting)]
            # ATTENTION: For the sake of testing:
            @players << Player.new(name: 'Foolano', local: false, host: false)
            # ATTENTION: For the sake of testing ends
            # unnatach text buffer from window
            self.text_input = nil
            # switch to phase 2
            @phase = [2]
          end
        else
          if(button_down?(Gosu::KB_C))
            # create game
            success, string = HTTPClient.get_new_match_id()
            if(success)
              @hosting = true
              capture_name(match_id: string)
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
          reset_to_phase_1()
        elsif(button_down?(Gosu::KB_I) && @players.first.host)
          # try to initialize phase 3
          if(@players.size >= 2)
            # initialize phase 3
            @phase = [3]
            @board = Board.new(@players)
            @dice = Dice.new()
          else
            enqueue_error('Participantes insuficientes.')
          end
        end
      when 3
        if(button_down?(Gosu::KB_ESCAPE) && (button_down?(Gosu::KB_LEFT_SHIFT) || button_down?(Gosu::KB_RIGHT_SHIFT)))
          # quit this match
          HTTPClient.post_match_quit()
          reset_to_phase_1()
        end
    end
  end

  # Called 60 times per second. Draws the graphics.
  def draw
    self.method("draw_phase_#{@phase.first}".to_sym).call()
  end

  private

  # @param possible_match_id [String]
  # Sets the @match_id and establish the "capture name" subphase.
  def capture_name(match_id:)
    @match_id = match_id
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
  end

  # @param error_message [String]
  def enqueue_error(error_message)
    @errors << error_message if !@errors.include?(error_message)
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

  # TODO: On this phase, we are already "online", so update lobby every X seconds. This mean update @players.
  # Phase 2.
  def draw_phase_2
    @phases_v[2].draw(0, 0, 0)
    # match id
    @font_v.draw_text(@match_id, 110, 160, 1)
    # players
    @players.each_with_index {|player, index| @font_v.draw_text(player.name, 50, 250 + (index * 25), 1, 1, 1, player.host ? 0xff_0000ff : 0xff_00ff00)}
    # draw any error if exist
    @font_v.draw_text("ERROR: #{@errors.join('. ')}", 50, 595, 1, 1, 1, 0xff_ff0000) if !@errors.empty?
  end

  # Phase 3.
  def draw_phase_3
    # draw board
    @phases_v[3].draw(0, 0, 0)
    draw_cells_content()
    # dice
    @dices_v[@dice.last_roll].draw(HEIGHT, BORDERS, 1)
    #
  end

  def draw_cells_content
    @board.cells.each_with_index do |cell, index|
      tokens = cell.tokens #: Array<Token>
      if (Cell::FINISH_CELLS.include?(index))
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
  end
end
