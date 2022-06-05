# Visual widget for phase #3, regarding actions that you can execute.
class VActions < VWidget

  attr_accessor :string

  X_POS = 716
  Y_POS = 134
  Z_POS = 1
  MAX_CHARS_PER_STRING = 66

  def draw
    @font.draw_text(@string, X_POS, Y_POS, Z_POS, 1, 1, 0xff_000000)
  end
end
