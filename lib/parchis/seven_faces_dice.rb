module SevenFacesDice

  # @return [Integer] number rolled.
  def roll
    @last_roll = rand(1..7)
  end
end
