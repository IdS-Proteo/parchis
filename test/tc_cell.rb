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

  def test_remove_token
    #to be implemented
  end

  def test_empty?
    assert @cell.empty?
  end

  def test_barrier?
    #to be implemented
  end

end
