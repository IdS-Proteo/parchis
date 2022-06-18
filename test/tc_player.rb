require 'minitest/autorun'
require_relative '../lib/parchis/player'

class TestPlayer < MiniTest::Test

  def setup
    @player = Player.new(name: 'self', local: false, host:false)
  end

  def test_to_s
    assert_equal('self', @player.to_s)
  end

  def test_local?
    refute(@player.local?)
  end

  def test_can_roll_dice?
    refute(@player.can_roll_dice?)
  end

  def test_can_move_a?
    refute(@player.can_move_a?)
  end

  def test_can_move_b?
    refute(@player.can_move_b?)
  end

  def test_can_move_c?
    refute(@player.can_move_c?)
  end

  def test_can_move_d?
    refute(@player.can_move_d?)
  end

  def test_clear_rights
    #to be implemented
  end

  def test_enable_to_move
    #to be implemented
  end

  def test_brackets
    #to be implemented
  end

end