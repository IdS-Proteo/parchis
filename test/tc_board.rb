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
    @player5 = Player.new(name: 'Self', local: true, host: !!@hosting)
    @player6 = Player.new(name: 'Foolano1', local: false, host: false)
    @player7 = Player.new(name: 'Foolano2', local: false, host: false)
    @player8 = Player.new(name: 'Foolano3', local: false, host: false)
    @players = [@player1, @player2, @player3, @player4]
    @players2 = [@player5, @player6, @player7, @player8]
    @board = Board.new(@players, player_turn: nil)
    @board2 = Board.new(@players, player_turn: nil)
  end

  def test_next_turn
    #UT 113
    @turn = @board.player_turn
    @board.next_turn
    if((@turn + 1) == 4)
      assert_equal(0, @board.player_turn)
    else
      assert_equal(@turn + 1, @board.player_turn)
    end
  end

  def test_dice_rolled
    @board.dice_rolled(result: 5)
    @player = @players[@player_turn]
    assert_match(@player.activity, :taking_token_out_of_its_house)

  end

  def test_perform_move
    #to be implemented
  end

  def test_player_quitted
    #to be implemented
  end

  def test_assign_tokens_to_players
    #UT009
    #UT107
    assert_equal(4, @player1.tokens.length)
    assert_equal(4, @player2.tokens.length)
    assert_equal(4, @player3.tokens.length)
    assert_equal(4, @player4.tokens.length)

  end

  def test_tokens_to_draw_from_house
    #UT107
    @board.send(:tokens_to_draw_from_house)
    @t_house = @board.tokens_to_draw_from_house(player: @player1)
    assert_equal(@player1.tokens.length, @t_house.length)

  end

  def test_initialize_cells
    #UT007
    # 100 cells + 4 houses * 4 cells - 1 extra ficticious cell in the middle of the board
    assert_equal(116, @board.cells.size - 1)
  end

  def test_assign_color_to_players
    #UT008
    assert_kind_of(Symbol, @player1.color)
    assert_kind_of(Symbol, @player2.color)
    assert_kind_of(Symbol, @player3.color)
    assert_kind_of(Symbol, @player4.color)
    #UT102
    refute_equal(@player1.color, @player5.color)
  end

  def test_tokens_in_play_that_can_be_moved_to_
    #to be implemented
  end

  def test_get_next_player_cell_ident
    #to be implemented
  end

  def test_tokens_in_barriers_that_can_be_moved
    #to be implemented
  end

  def test_check_possible_regular_moves
    #to be implemented
  end

  def test_send_token_to_its_house
    #to be implemented
  end
  
end


