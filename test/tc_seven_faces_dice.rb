require 'minitest/autorun'
require 'minitest/junit'
require_relative '../lib/parchis/six_faces_dice'
require_relative '../lib/parchis/dice'
require_relative '../lib/parchis/seven_faces_dice'

class TestSevenFacesDice < MiniTest::Test

def setup
    @seven_faces_dice=Dice.new()
end

def test_roll
    assert_includes [1,2,3,4,5,6,7],@seven_faces_dice.roll()
end

end