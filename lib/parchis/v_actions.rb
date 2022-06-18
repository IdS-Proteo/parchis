# Visual widget for phase #3, regarding actions that you can execute.
class VActions < VWidget

  attr_accessor :string

  X_POS = 716
  Y_POS = 134
  Z_POS = 1
  MAX_CHARS_PER_STRING = 66
  LOC_EN_SP = {red: 'rojo', green: 'verde', blue: 'azul', yellow: 'amarillo'}

  # @param board [Board]
  def initialize(board:, dice:, font: nil)
    @board = board
    @dice = dice
    super(font: font)
  end

  def update
    player_in_turn = @board.players[@board.player_turn]
    @string = \
      if(player_in_turn.local?)
        # question phase of the turn
        if(player_in_turn.can_roll_dice?)
          "Es tu turno! Arroja el dado, mantén [SpaceBar]."
        else
          case player_in_turn.activity
            when :taking_token_out_of_its_house
              "Saca un token de tu casa. Elige #{get_string_of_token_options(player_in_turn)}."
            when :moving_tokens_in_play
              "Puedes mover #{get_string_of_token_options(player_in_turn)}."
            when :moving_token_out_of_barrier
              "Estás obligado a mover de tu/s barrera/s #{get_string_of_token_options(player_in_turn)}."
            when :cant_do_anything
              if(@dice.last_roll == 6 && !@dice.cant_roll_anymore_for_current_player)
                "Oh :( no puedes hacer nada, pero sacaste 6, repite el tiro!"
              else
                "Oh :( no puedes hacer nada."
              end
            else
              "Solo si arrojaste un 6 en tu primera tirada puedes repetir."
          end
        end
      else
        "Es el turno del jugador #{LOC_EN_SP[player_in_turn.color]}."
      end
  end

  def draw
    @font.draw_text(@string, X_POS, Y_POS, Z_POS, 1, 1, 0xff_000000)
  end

  private

  # @param player_in_turn [String]
  # @return [String]
  def get_string_of_token_options(player_in_turn)
    string = []
    string << '[A]' if player_in_turn.can_move_a?
    string << '[B]' if player_in_turn.can_move_b?
    string << '[C]' if player_in_turn.can_move_c?
    string << '[D]' if player_in_turn.can_move_d?
    if(string.size == 1)
      string.first
    elsif(string.size == 2)
      string.join(' o ')
    else
      string[0..-2].join(', ') + ' o ' + string.last
    end
  end
end
