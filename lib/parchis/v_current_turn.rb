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
    @board = board
    super(font: font)
  end

  def update
    player_turn = @board.players[@board.player_turn]
    @string = "<c=000000>Turno actual:</c> <c=#{COLOR_SYM_TO_HEX_MAP[player_turn.color]}>#{player_turn}</c>"
  end

  def draw
    @font.draw_markup(@string, X_POS, Y_POS, Z_POS, 1, 1)
  end
end
