require 'minitest/autorun'
require_relative '../lib/parchis/board'
require_relative '../lib/parchis/player'
require_relative '../lib/parchis/token'
require_relative '../lib/parchis/cell'
require_relative '../lib/parchis/parchis'


class TestBoard < MiniTest::Test

    def setup
        @board=Board.new([player1,player2,player3,player4])
    end

    def test_next_turn
        assert_includes([0,1,2,3],player1.next_turn())
    end


    def test_player_turn
        assert_equal(player1,player_turn)
    end

    def test_debug_tokens_positioning
        
    end

    def test_assign_tokens_to_players
        
    end

    def test_initialize_cells

    end

    def test_assign_color_to_players
        
    end

end


