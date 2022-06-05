require 'minitest/autorun'
require_relative '../lib/parchis/six_faces_dice'
require_relative '../lib/parchis/dice'
require_relative '../lib/parchis/seven_faces_dice'


class TestSixFacesDice < MiniTest::Test

    def setup
        @six_faces_dice=Dice.new()
        @last_roll=0
    end
    
    def test_roll
        if(@last_roll==6)
            if ((@last_roll = rand(1..6)) == 6)
                #esto tiene que haber una mejor manera pero no sé cuál
                assert self.class.include(SevenFacesDice)
            end
            @last_roll
        else
            assert_includes [1,2,3,4,5,6],@six_faces_dice.roll()
        end
    end
    
end