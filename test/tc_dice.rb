require 'minitest/autorun'
require_relative '../lib/parchis/six_faces_dice'
require_relative '../lib/parchis/dice'

class TestDice < MiniTest::Test

  def setup
    @dice = Dice.new()
  end

  def test_set_unknown_state
    refute @dice.set_unknown_state
  end

end