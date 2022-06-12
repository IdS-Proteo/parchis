require 'minitest/autorun'
require_relative '../lib/parchis/parchis'
require_relative '../lib/parchis/cell'
require_relative '../lib/parchis/token'

class TestCell < MiniTest::Test

  def setup
    @cell = Cell.new(1)
    @token = Token.new(:red, 'A')
  end

  def test_place_token
    #assert @cell.place_token(@token)
  end

  def test_empty?
    assert @cell.empty?
  end

  def test_get_length_coords
    # 100 cells + 4 houses * 4 cells - 1 extra ficticious cell in the middle of the board
    assert_equal(116, Cell::COORDS.length - 1)
  end
end
