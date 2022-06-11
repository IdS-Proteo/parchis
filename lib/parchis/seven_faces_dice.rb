module SevenFacesDice

  # @return [Integer] number rolled.
  def roll
    if(@last_roll == 0)
      # first roll for this player; if it's not 6, can't roll again
      if((@last_roll = rand(1..7)) != 6)
        @cant_roll_anymore_for_current_player = true
      end
    else
      # this is a second run, and player got 6 in last turn (otherwise, won't have rolled this roll)
      @last_roll = rand(1..7)
      # can't roll more than twice
      @cant_roll_anymore_for_current_player = true
    end
    @last_roll
  end
end
