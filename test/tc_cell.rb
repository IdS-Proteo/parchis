require 'minitest/autorun'
require 'minitest/junit'
require_relative '../lib/parchis/parchis'
require_relative '../lib/parchis/cell'
require_relative '../lib/parchis/token'

class TestCell < MiniTest::Test

  def setup
    @cell = Cell.new(1)
    @token = Token.new(:red,@cell,'A')
  end

  def test_place_token
    assert @cell.place_token(@token)
  end

  def test_empty?
    refute @cell.empty?
  end

  def test_get_length_coords
    assert_equal(117, Cell::COORDS.length)
  end
end
