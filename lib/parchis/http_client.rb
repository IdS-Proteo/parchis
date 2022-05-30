# TODO: This methods must implement timeout too.
# Helper class to talk with the game's server.
class HTTPClient

  # Prevent class instantiation. Singleton pattern.
  def self.new; end

  # TODO: Implement.
  # @return [Array(Boolean, String)] such as [false, "Error message"] or [true, "match_id"]
  # Returns a valid match id or an error. Doesn't raise an exception.
  def self.get_new_match_id
    # ATTENTION: Mock values
    [true, "1234567890"]
  end

  # TODO: Implement.
  # @param match_id [String]
  # @return [Array(Boolean, Object)] such as [false, "Feedback or error message"] if doesn't exist or something went wrong; [true, nil] otherwise
  def self.get_match_lobby_existence(match_id:)
    # ATTENTION: Mock values
    [true, nil]
  end

  # TODO: Implement.
  # Makes the server aware that we are quiting the match. Relaxed, doesn't check if the message got there or not.
  def self.post_match_quit

  end
end