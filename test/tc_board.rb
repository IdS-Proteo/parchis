require 'minitest/autorun'
require_relative '../lib/parchis/board'
require_relative '../lib/parchis/player'
require_relative '../lib/parchis/token'
require_relative '../lib/parchis/parchis'
require_relative '../lib/parchis/cell'

class TestBoard < MiniTest::Test

  attr_accessor :player_turn

  def setup
    @player1 = Player.new(name: 'Self', local: true, host: !!@hosting)
    @player2 = Player.new(name: 'Foolano1', local: false, host: false)
    @player3 = Player.new(name: 'Foolano2', local: false, host: false)
    @player4 = Player.new(name: 'Foolano3', local: false, host: false)
    @players = [@player1, @player2, @player3, @player4]
    @board = Board.new(@players, player_turn: nil)
  end

  def test_next_turn
    #uT 113
    @turn = @board.player_turn
    @board.next_turn
    if((@turn + 1) == 4)
      assert_equal(0, @board.player_turn)
    else
      assert_equal(@turn + 1, @board.player_turn)
    end
  end

  def test_dice_rolled

  end

  #def test_debug_tokens_positioning
        
  #end

  def test_assign_tokens_to_players
    @board.send(:assign_tokens_to_players)
    assert_equal(4, @player1.tokens.length)
    assert_equal(4, @player2.tokens.length)
    assert_equal(4, @player3.tokens.length)
    assert_equal(4, @player4.tokens.length)

  end

  def test_initialize_cells
    assert_equal(117, @board.cells.size)
  end

  def test_assign_color_to_players
    assert_kind_of(Symbol, @player1.color)
    assert_kind_of(Symbol, @player2.color)
    assert_kind_of(Symbol, @player3.color)
    assert_kind_of(Symbol, @player4.color)
  end

end


