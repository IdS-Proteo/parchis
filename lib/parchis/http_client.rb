# TODO: This methods must implement timeout too.
# TODO: On server, after get_match_lobby_existence() call, it must reserve slot giving a fake name such as "Player #" where # is the id returned.
# Helper class to talk with the game's server.
class HTTPClient

  ROOT_URL = ''

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
  # @return [Array(Object, Object)] such as [false, "Feedback or error message"] if doesn't exist or something went wrong; [#Integer, nil] otherwise indicating
  # the player id assigned which is associated to the index of @players.
  def self.get_match_lobby_existence(match_id:)
    # ATTENTION: Mock values
    [0, nil]
  end

  # TODO: Implement. La info a postear tiene que ser la que devuelve get_lobby_state(), o sea, name del player, player id, y si es o no host.
  # @param match_id [String]
  # @param player [Player]
  def self.post_joining_to_lobby(match_id:, player:)
    
  end

  def self.post_leaving_lobby(match_id:, player:)

  end

=begin
  TODO: Implement: could also return [:game_started, <Player>] where every #Player will have its color set.
  @param match_id [String]
  @return [Array<Player>, false] false if something went wrong such as if the lobby doesn't exist anymore. Otherwise, return an #Array of players.
  The state of a lobby is basically the players on it. Brings a JSON like:
  {
    "code": 200,
    "players": [
      {
        "name": "foo",
        "host": true,
        "color": null
      },
      {
        "name": "bar",
        "host": false,
        "color": null
      }
    ]
  }
=end
  def self.get_lobby_state(match_id:, player_id:)
    # ...
    json = JSON.parse(response)
    if(json['code'] == 200)
      players = []
      json['players'].each_with_index do |player, index|
        players << Player.new(name: player['name'], local: player_id == index ? true : false, host: player['host'], color: (c = player['color']) ? c.to_sym : nil)
      end
      players
    else
      false
    end
  end

  # TODO: Implement.
  # Pass colors of each player in an array, the order matters. Also pass the player id (@players.compact! index) of the current turn.
  def self.post_match_started(match_id:, colors:, player_turn:)

  end

  # @param match_id [String]
  # @return [Integer]
  # Return the current player turn (index of @players.compact!) of certain match.
  def self.get_player_turn(match_id:)

  end

  # TODO: Implement.
  # Makes the server aware that we are quiting the match. Relaxed, doesn't check if the message got there or not.
  def self.post_match_quit

  end
end