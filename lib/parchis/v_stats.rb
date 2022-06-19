# Visual widget for phase #3. Show the players statistics.
class VStats < VWidget

  X_POS_0 = 716
  X_POS_1 = 958
  Y_POS_0 = 182
  Y_POS_1 = 206
  Y_POS_2 = 230
  Y_POS_3 = 254
  Y_POS_4 = 278
  Z_POS = 1
  HEADER = "<b>Jugador                                                 1     2     3     4     5     6     7  CA  TC  BG</b>".freeze

  # @param board [Board]
  def initialize(board:, font: nil)
    @board = board
    super(font: font)
  end

  def update
    # clean @strings
    @strings = []
    @board.players.each do |player|
      next if !player
      player_metadata = []
      # player name
      player_data = ["<c=#{COLOR_SYM_TO_HEX_MAP[player.color]}>#{player.name}</c>", player_metadata]
      # rolls
      1.upto(7) do |n|
        player_metadata << format("%03d", player.rolls[n])
      end
      # ca (celdas avanzadas)
      player_metadata << format("%03d", player.cells_advanced)
      # tc (tokens comidos)
      player_metadata << format("%03d", player.tokens_eaten)
      # bg (barreras generadas)
      player_metadata << format("%03d", player.barriers_generated)
      # insert player data into strings
      @strings << player_data
    end
  end

  def draw
    # title, fixed
    @font.draw_markup(HEADER, X_POS_0, Y_POS_0, Z_POS, 1, 1, 0xff_000000)
    # next strings are variable
    @strings.each_with_index do |player_data, index|
      y_pos = VStats.const_get("Y_POS_#{index + 1}".to_sym)
      # player name
      @font.draw_markup(player_data.first, X_POS_0, y_pos, Z_POS, 1, 1)
      # player metadata
      @font.draw_text(player_data.last.join(' '), X_POS_1, y_pos, Z_POS, 1, 1, 0xff_000000)
    end
  end
end
