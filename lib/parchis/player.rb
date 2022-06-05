# Parchis #Player.
class Player

  attr_reader :name
  # @tokens get his value once the game start which is after a #Player is created
  # @color get his value on game started. It's one of :green, :yellow, :red, :blue
  # @host is a Boolean that tells if this player is the host of the match or not
  # @local is a Boolean that tells if this is you or a player on another client
  attr_accessor :tokens, :color, :host, :local
  attr_writer :can_roll_dice

  # @param name [String]
  def initialize(name:, local: false, host: false)
    @name = name
    @local = local
    @host = host
  end

  # @return [String]
  def to_s
    @name
  end

  # @return [Boolean]
  def can_roll_dice?
    !!@can_roll_dice
  end
end
