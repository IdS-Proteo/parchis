require 'minitest/autorun'
require_relative '../lib/parchis/board'
require_relative '../lib/parchis/player'
require_relative '../lib/parchis/token'
require_relative '../lib/parchis/parchis'
require_relative '../lib/parchis/cell'

#this is a test push to trigger jenkins

class TestBoard < MiniTest::Test

    def setup
        @player1 = Player.new(name: 'Self', local: true, host: !!@hosting)
        @player2 = Player.new(name: 'Foolano1', local: false, host: false)
        @player3 = Player.new(name: 'Foolano2', local: false, host: false)
        @player4 = Player.new(name: 'Foolano3', local: false, host: false)
        @players = [@player1, @player2, @player3, @player4]
        @board = Board.new(@players, player_turn: nil)
    end

    def test_next_turn
        assert_equal(1, @board.next_turn)
        assert_equal(2, @board.next_turn)
        assert_equal(3, @board.next_turn)
        assert_equal(0, @board.next_turn)
    end


    def test_player_turn
        assert_equal('Self', @board.player_turn.to_s)
    end

    #def test_debug_tokens_positioning
        
    #end

    def test_assign_tokens_to_players
        @board.send(:assign_tokens_to_players)
        assert_equal 4, @player1.tokens.length
        assert_equal 4, @player2.tokens.length
        assert_equal 4, @player3.tokens.length
        assert_equal 4, @player4.tokens.length

    end

    def test_initialize_cells
        assert_equal 117, @board.cells.size
    end

    def test_assign_color_to_players
        assert_kind_of Symbol, @player1.color
        assert_kind_of Symbol, @player2.color
        assert_kind_of Symbol, @player3.color
        assert_kind_of Symbol, @player4.color
    end

end


