class Delayer

  @@active_events = []

  def self.update
    @@active_events.each_with_index {|e, index| e.update(index)}
    @@active_events.compact!
  end

  # @param seconds [Float]
  def initialize(seconds, &block)
    @created_at = Time.now
    @delay = seconds
    @callable = block
    @@active_events << self
  end

  # @param id [Integer]
  def update(id)
    if((Time.now - @created_at) > @delay)
      @callable.call
      @@active_events[id] = nil
    end
  end
end
