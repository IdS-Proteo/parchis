module SixFacesDice

  # @return [Integer] number rolled
  # If you roll 6 two times in a row, the dice transforms into a seven faces one.
  def roll
    if(@last_roll == 6)
      if((@last_roll = rand(1..6)) == 6)
        # super-power enabled
        self.class.include(SevenFacesDice)
      end
      @last_roll
    else
      @last_roll = rand(1..6)
    end
  end
end
