# An instance of this class represent a GUI widget.
class VWidget

  # @param font [Gosu::Font]
  def initialize(font: nil)
    # almost all widgets use a font
    @font = font
  end
end
