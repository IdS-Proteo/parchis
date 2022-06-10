require 'minitest/autorun'
require 'minitest/junit'
require_relative '../lib/parchis/six_faces_dice'
require_relative '../lib/parchis/dice'

class TestDice < MiniTest::Test

    def setup
        @dice = Dice.new()
    end

    def test_set_unknown_state
        assert_equal(0,@dice.set_unknown_state)
    end

end