class Dice

  # @cant_roll_anymore_for_current_player will be true if the player rolled two six in a row. Must be restarted (through set_unkown_state()) on a new player turn
  attr_reader :last_roll, :cant_roll_anymore_for_current_player

  # brings method Dice#roll!()
  include SixFacesDice

  # Constructor.
  def initialize
    # you can't roll 0, but that means you are in the "unknown" dice state
    set_unknown_state()
  end

  # Sets @last_roll to 0 & @cant_roll_anymore_for_current_player to false.
  def set_unknown_state
    @last_roll = 0
    @cant_roll_anymore_for_current_player = false
  end

  # @param value [Integer]
  def force_last_roll(value:)
    @last_roll = value
  end

  def roll
    if(@last_roll == 0)
      # first roll for this player; if it's not 6, can't roll again
      if((@last_roll = roll!()) != 6)
        @cant_roll_anymore_for_current_player = true
      end
    else
      # this is a second run, and player got 6 in last turn (otherwise, won't have rolled this roll)
      if((@last_roll = roll!()) == 6)
        # super-power enabled if not already
        self.class.include(SevenFacesDice) if !self.class.include?(SevenFacesDice)
      end
      # can't roll more than twice
      @cant_roll_anymore_for_current_player = true
    end
    @last_roll
  end
end
