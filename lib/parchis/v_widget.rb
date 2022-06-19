# An instance of this class represent a GUI widget. Every sub-class must implement update().
class VWidget

  COLOR_SYM_TO_HEX_MAP = {
    red: 'FF0000',
    green: '00FF00',
    blue: '0000FF',
    yellow: 'FCED21'
  }.freeze

  # @param font [Gosu::Font]
  def initialize(font: nil)
    # almost all widgets use a font
    @font = font
    update()
  end
end
