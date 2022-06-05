class Dice

  attr_reader :last_roll

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
  end
end
