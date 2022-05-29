class Player

  attr_reader :name, :color
  attr_accessor :tokens

  # @param color [Symbol], one of :green, :yellow, :red, :blue
  # @param name [String]
  def initialize(color, name)
    @color = color
    @name = name
  end
end
