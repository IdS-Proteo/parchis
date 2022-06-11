# A #Player token that live somehow in a #Cell of a #Board. Only 4 of this per player could exist.
class Token

  attr_reader :color, :label
  attr_accessor :cell

  # @param color [Symbol]
  # @param cell [Cell] the cell where this token start
  # @param label [String] how externally will be represented. We expect a letter here, such as "A", "B", "C", "D".
  def initialize(color, label)
    @color = color
    @label = label
  end
end
