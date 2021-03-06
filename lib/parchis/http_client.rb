# Helper class to talk with the game's server.
class HTTPClient

  ROOT_URL = "https://warm-lowlands-98832.herokuapp.com"

  # Prevent class instantiation. Singleton pattern.
  def self.new; end

=begin
  LOBBY RELATED METHODS
=end

  # @return [Array(Boolean, String)] such as [false, "Error message"] or [true, "match_id"]
  # Returns a valid match id or an error. Doesn't raise an exception.
  def self.get_new_match_id
    response = Net::HTTP.get_response(URI("#{ROOT_URL}/new_match_id"), {'Accept' => 'text/plain'})
    if(response.code == '200')
      [true, response.body]
    else
      [false, 'Problema en el server']
    end
  end

  # @param match_id [String]
  # @return [Array(Object, Object)] such as [false, "Feedback or error message"] if doesn't exist or something went wrong; [#Integer, nil] otherwise indicating
  # the player id assigned which is associated to the index of @players. Server currently return #String >= '0' for slot reserver in an existent lobby, otherwise
  # returns 'false' if the lobby doesn't exist.
  def self.get_match_lobby_existence(match_id:)
    # prepare and send call
    params = {"match_id" => match_id}
    uri = URI("#{ROOT_URL}/match_lobby_existence")
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri, {'Accept' => 'text/plain'})
    # parse response
    case response.code
      when '200'
        [response.body.to_i, nil]
      when '460'
        [false, 'Esa partida-lobby está FULL (4 jugadores).']
      when '404'
        [false, 'Esa partida-lobby no existe.']
      when '461'
        [false, 'Este juego ya comenzó.']
    end
  end

  # @param match_id [String]
  # @param player [Player]
  # @param player_id [Integer]
  # We are aware that there's no check for errors. Programmed to be implemented in posterior version.
  def self.post_joining_to_lobby(match_id:, player:, player_id:)
    body = {'match_id' => match_id, 'player' => {'id' => player_id, 'name' => player.name, 'host' => player.host}}.to_json
    Net::HTTP.post(URI("#{ROOT_URL}/joining_to_lobby"), body, {'Content-Type' => 'application/json'})
  end

  # @param match_id [String]
  # @param player_id [Integer]
  def self.post_leaving_lobby(match_id:, player_id:)
    body = {'match_id' => match_id, 'player_id' => player_id}.to_json
    Net::HTTP.post(URI("#{ROOT_URL}/leaving_lobby"), body, {'Content-Type' => 'application/json'})
  end

=begin
  @param match_id [String]
  @return [Array<Player>, false] false if something went wrong such as if the lobby doesn't exist anymore. Otherwise, returns an #Array, which could be only
  conformed by #Player objects, or it could have as first object :game_started, indicating that the game has been launched by the host.
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
    # prepare and send call
    params = {"match_id" => match_id}
    uri = URI("#{ROOT_URL}/lobby_state")
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri, {'Accept' => 'application/json'})
    # parse response
    if(response.code == '200')
      json = JSON.parse(response.body)
      players = []
      json['players'].each_with_index do |player, index|
        if(player)
          players << Player.new(
            name: player['name'],
            local: ((player_id == index) ? true : false),
            host: player['host'],
            color: ((c = player['color']) ? c.to_sym : nil))
        else
          players << player
        end
      end
      # check if the game has started
      if(json['game_started'])
        [:game_started, *players]
      else
        players
      end
    else
      false
    end
  end

  # @param match_id [String]
  # @param colors [Array<Symbol>] such as [:green, :blue, :red]
  # @param player_turn [Integer]
  # Pass colors of each player in an array, the order matters. Also pass the player id (@players.compact! index) of the current turn.
  def self.post_match_started(match_id:, colors:, player_turn:)
    body = {'match_id' => match_id, 'colors' => colors, 'player_turn' => player_turn}.to_json
    Net::HTTP.post(URI("#{ROOT_URL}/match_started"), body, {'Content-Type' => 'application/json'})
  end

  # @param match_id [String]
  # @return [Integer, false]
  # Return the current player turn (index of @players.compact!) of certain match, false if something went wrong. Must be called after a match started, never before.
  def self.get_player_turn(match_id:)
    # prepare and send call
    params = {"match_id" => match_id}
    uri = URI("#{ROOT_URL}/player_turn")
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri, {'Accept' => 'text/plain'})
    # parse response
    if(response.code == '200' && !response.body.empty?)
      response.body.to_i
    else
      nil
    end
  end

=begin
  GAME RELATED METHODS
=end

  # @param match_id [String]
  # @return [Array<Hash<String, Object>>, nil] nil if something went wrong such as match non existent.
  def self.get_game_last_events(match_id:)
    # prepare and send call
    params = {"match_id" => match_id}
    uri = URI("#{ROOT_URL}/game_last_events")
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri, {'Accept' => 'application/json'})
    # parse response
    if(response.code == '200')
      JSON.parse(response.body).[]('levs') #: Array<Hash<String, Object>> such as [{'ev' => 'dr4', 'id' => 51}, ...]
    else
      nil
    end
  end

  # @param match_id [String]
  # @param result [Integer] of the roll
  def self.post_dice_rolled(match_id:, result:)
    body = {'match_id' => match_id, 'dr' => result}.to_json
    Net::HTTP.post(URI("#{ROOT_URL}/dice_rolled"), body, {'Content-Type' => 'application/json', 'Accept' => 'text/plain'}).body.to_i
  end

  # @param match_id [String]
  # @param token_color [Symbol]
  # @param token_label [String]
  # @param cells_to_move [Integer]
  # @param end_of_turn [Boolean]
  # This could also post the end of the turn.
  def self.post_token_moved(match_id:, token_color:, token_label:, cells_to_move:, end_of_turn:)
    body = {'match_id' => match_id, 'tm' => "#{token_color.to_s.[](0)}#{token_label}#{cells_to_move}#{end_of_turn ? 't' : 'f'}"}.to_json
    Net::HTTP.post(URI("#{ROOT_URL}/token_moved"), body, {'Content-Type' => 'application/json', 'Accept' => 'text/plain'}).body.to_i
  end

  # @param match_id [String]
  # @param player_id [Integer]
  # Makes the server aware that we are quiting the match. Relaxed, doesn't check if the message got there or not.
  def self.post_match_quit(match_id:, player_id:)
    body = {'match_id' => match_id, 'player_id' => player_id}.to_json
    Net::HTTP.post(URI("#{ROOT_URL}/match_quit"), body, {'Content-Type' => 'application/json'})
  end
end
