module SixFacesDice

  # @return [Integer] number rolled
  # If you roll 6 two times in a row, the dice transforms into a seven faces one.
  def roll
    if(@last_roll == 0)
      # first roll for this player; if it's not 6, can't roll again
      if((@last_roll = rand(1..6)) != 6)
        @cant_roll_anymore_for_current_player = true
      end
    else
      # this is a second run, and player got 6 in last turn (otherwise, won't have rolled this roll)
      if((@last_roll = rand(1..6)) == 6)
        # super-power enabled
        self.class.include(SevenFacesDice)
      end
      # can't roll more than twice
      @cant_roll_anymore_for_current_player = true
    end
    @last_roll
  end
end
