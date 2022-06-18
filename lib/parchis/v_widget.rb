# An instance of this class represent a GUI widget. Every sub-class must implement update().
class VWidget

  # @param font [Gosu::Font]
  def initialize(font: nil)
    # almost all widgets use a font
    @font = font
    update()
  end
end
