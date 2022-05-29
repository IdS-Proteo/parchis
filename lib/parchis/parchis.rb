require 'gosu'

class Parchis < Gosu::Window
  
  WIDTH = 1254
  HEIGHT = 705
  BORDERS = 11
  ASSETS_PATH = "#{File.dirname(File.dirname(File.dirname(__FILE__)))}/assets"
  
  def initialize
    super(WIDTH, HEIGHT)
    initialize_view()
    initialize_model()
  end
  
  def update

  end
  
  def draw
    # draw board
    @board_v.draw(0, 0, 0)
    # draw cells content
    @board.cells.each_with_index do |cell, index|
      tokens = cell.tokens #: Array<Token>
      if(Cell::FINISH_CELLS.include?(index))
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
      elsif(tokens.size == 1)
        # mid positioning
        draw_token(token: tokens.first, coords: cell.coords_mid)
      elsif(tokens.size == 2)
        # top and bottom posittioning
        draw_token(token: tokens.first, coords: cell.coords_top)
        draw_token(token: tokens.last, coords: cell.coords_bottom)
      end
    end

    # WARNING: Testing
    @dice_v.draw(HEIGHT, BORDERS, 1)
    @font_v.draw_text("Tres tristes tigres comen trigo en un trigal.", HEIGHT, HEIGHT - 30, 1)
    # WARNING: Testing
  end

  private

  # @param token [Token]
  # @param coords [Hash<Symbol => Integer>]
  def draw_token(token:, coords:)
    @tokens_v[token.color].draw(coords[:x], coords[:y], 1)
    # draw its label, i.e.: "A", "B", ...
    @font_v.draw_text(token.label, coords[:x] + 7, coords[:y] + 5, 2, 1, 1, 0xff_000000)
  end

  # Initializes the view.
  def initialize_view
    self.caption = "Parchís"

    @board_v = Gosu::Image.new("#{ASSETS_PATH}/img/parchis.png")

    @tokens_v = {red: Gosu::Image.new("#{ASSETS_PATH}/img/tokens/red_token.png"),
                 blue: Gosu::Image.new("#{ASSETS_PATH}/img/tokens/blue_token.png"),
                 yellow: Gosu::Image.new("#{ASSETS_PATH}/img/tokens/yellow_token.png"),
                 green: Gosu::Image.new("#{ASSETS_PATH}/img/tokens/green_token.png")}

    # WARNING: Testing
    @dice_v = Gosu::Image.new("#{ASSETS_PATH}/img/dices/dice_one.png")
    @font_v = Gosu::Font.new(16)
    # WARNING: Testing
  end

  # Initializes the model.
  def initialize_model
    # WARNING: Testing
    @player_a = Player.new(:yellow, 'Gabe')
    @player_b = Player.new(:blue, 'Gabe')
    @player_c = Player.new(:red, 'Gabe')
    @player_d = Player.new(:green, 'Gabe')
    @board = Board.new([@player_a, @player_b, @player_c, @player_d])
    # @board.debug_tokens_positioning(tokens_amount: :max)
    @board.debug_tokens_positioning(tokens_amount: :min)
    # WARNING: Testing
  end
end
