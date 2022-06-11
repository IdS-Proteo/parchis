class Dice

  # @cant_roll_anymore_for_current_player will be true if the player rolled two six in a row. Must be restarted (through set_unkown_state()) on a new player turn
  attr_reader :last_roll, :cant_roll_anymore_for_current_player

  # brings method Dice#roll()
  include SixFacesDice

  # Constructor.
  def initialize
    # you can't roll 0, but that means you are in the "unknown" dice state
    set_unknown_state()
  end

  # Sets @last_roll to 0.
  def set_unknown_state
    @last_roll = 0
    @cant_roll_anymore_for_current_player = false
  end
end
