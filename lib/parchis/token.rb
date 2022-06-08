# A #Player token that live somehow in a #Cell of a #Board. Only 4 of this per player could exist.
class Token

  attr_reader :color, :label, :cell

  # @param color [Symbol]
  # @param cell [Cell] the cell where this token start
  # @param label [String] how externally will be represented. We expect a letter here, such as "A", "B", "C", "D".
  def initialize(color, cell, label)
    @color = color
    @cell = cell
    # this method is only called on board initialization, hence every cell are empty, no need to check return value of Cell#place_token()
    @cell.place_token(self)
    @label = label
  end
end
