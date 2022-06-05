# Visual widget for phase #3, that shows which player has the current turn.
class VCurrentTurn < VWidget

  COLOR_SYM_TO_HEX_MAP = {
    red: 'FF0000',
    green: '00FF00',
    blue: '0000FF',
    yellow: 'FCED21'
  }.freeze
  X_POS = 716
  Y_POS = 646
  Z_POS = 1

  # @param board [Board]
  def initialize(board:, font: nil)
    super(font: font)
    @board = board
  end

  def draw
    player_turn = @board.player_turn
    @font.draw_markup("<c=000000>Turno actual:</c> <c=#{COLOR_SYM_TO_HEX_MAP[player_turn.color]}>#{player_turn}</c>", X_POS, Y_POS, Z_POS, 1, 1)
  end
end
