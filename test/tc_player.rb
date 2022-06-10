require 'minitest/autorun'
require 'minitest/junit'
require_relative '../lib/parchis/player'

class TestPlayer < MiniTest::Test

    def setup
        @player = Player.new( name: 'self',local: false, host:false)
    end

    def test_to_s
        assert_equal('self',@player.to_s)
    end

    def test_can_roll_dice?
        refute(@player.can_roll_dice?)
    end

end