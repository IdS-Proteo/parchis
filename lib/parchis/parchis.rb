require 'gosu'

class Parchis < Gosu::Window
  
  WIDTH = 1254
  HEIGHT = 705
  BORDERS = 11
  ASSETS_PATH = "#{File.dirname(File.dirname(File.dirname(__FILE__)))}/assets"
  
  def initialize
    super(WIDTH, HEIGHT)
    self.caption = "Parchís"
    
    @board = Gosu::Image.new("#{ASSETS_PATH}/img/parchis.png")
    
    # WARNING: Testing
    @dice = Gosu::Image.new("#{ASSETS_PATH}/img/dices/dice_one.png")
    @font = Gosu::Font.new(16)
    # WARNING: Testing
  end
  
  def update
    a = 'a'
    a.is_a?(String)
  end
  
  def draw
    @board.draw(0, 0, 0)
    # WARNING: Testing
    @dice.draw(HEIGHT, BORDERS, 1)
    @font.draw_text("Tres tristes tigres comen trigo en un trigal.", HEIGHT, HEIGHT - 30, 1)
    # WARNING: Testing
  end
end
