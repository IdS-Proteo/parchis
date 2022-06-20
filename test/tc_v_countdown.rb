require 'minitest/autorun'
require_relative '../lib/parchis/v_widget'
require_relative '../lib/parchis/v_countdown'

class TestVCountdown < MiniTest::Test

  TURN_TIMEOUT = 120
  def setup
    @countdown = VCountdown.new()
    @countdown_start = Time.now
    @delta = (Time.now - @countdown_start).floor
    @countdown = TURN_TIMEOUT - @delta
  end

  def test_reset_countdown
    #to be implemented
  end

  def test_update
    #to be implemented
  end

  def test_draw
    #UT118
    #this section only tests that the time shown is between 0 and 2 mins
    assert_in_delta(60, @countdown, 60)
  end

end