# Visual widget for phase #3. Is the countdown for current turn.
class VCountdown < VWidget

  # in seconds
  TURN_TIMEOUT = 120
  X_POS = 1166
  Y_POS = 28
  Z_POS = 1

  def reset_countdown
    @countdown_start = Time.now
  end

  def update
    reset_countdown()
  end

  # @return [Boolean]
  def out?
    (Time.now - @countdown_start) >= TURN_TIMEOUT
  end

  # Draw the widget.
  def draw
    delta = (Time.now - @countdown_start).floor
    countdown = [0, TURN_TIMEOUT - delta].max
    @font.draw_text("#{countdown / 60}:#{"%02d" % (countdown % 60)}", X_POS, Y_POS, Z_POS, 1, 1, 0xff_000000)
  end
end
