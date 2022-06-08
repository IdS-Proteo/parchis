# Parchis #Player.
class Player

  attr_reader :name
  # @tokens get his value once the game start which is after a #Player is created
  # @color get his value on game started. It's one of :green, :yellow, :red, :blue
  # @host is a Boolean that tells if this player is the host of the match or not
  # @local is a Boolean that tells if this is you or a player on another client
  attr_accessor :tokens, :color, :host
  # @activity could be one of :taking_token_out_of_its_house, :moving_tokens_in_play
  attr_writer :can_roll_dice, :can_move_a, :can_move_b, :can_move_c, :can_move_d, :activity

  # @param name [String]
  def initialize(name:, local: false, host: false, color: nil)
    @name = name
    @local = local
    @host = host
    @color = color
    clear_rights()
  end

  # @return [String]
  def to_s
    @name
  end

  # @return [Boolean]
  def local?
    @local
  end

  # @return [Boolean]
  def can_roll_dice?
    @can_roll_dice
  end

  # @return [Boolean]
  def can_move_a?
    @can_move_a
  end

  # @return [Boolean]
  def can_move_b?
    @can_move_b
  end

  # @return [Boolean]
  def can_move_c?
    @can_move_c
  end

  # @return [Boolean]
  def can_move_d?
    @can_move_d
  end

  # This player has no rights.
  def clear_rights
    @can_roll_dice = false
    @can_move_a = false
    @can_move_b = false
    @can_move_c = false
    @can_move_d = false
    @activity = nil
  end

  # @param tokens [Array<Token>]
  def enable_to_move(tokens)
    tokens.each {|t| instance_variable_set("@can_move_#{t.label.downcase}".to_sym, true)}
  end
end
