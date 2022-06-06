# An instance of this class keeps the lobby updated.
class LobbyUpdater

  UPDATE_INTERVAL = 2.5 # seconds

  # @param players [Array<Player>]
  # @param match_id [String]
  # @param player_id [Integer], 0..X
  def initialize(players:, match_id:, player_id:)
    @players = players
    @match_id = match_id
    @player_id = player_id
    @last_update = Time.now
  end

  # Joins the lobby with @match_id. Previously to this call, a check is supposed to be made for slot.
  def join_lobby
    HTTPClient.post_joining_to_lobby(match_id: @match_id, player: @players[@player_id])
  end

  def leave_lobby
    HTTPClient.post_leaving_lobby(match_id: @match_id, player: @players[@player_id])
  end

  # @return [Array<Player>, Array(:game_started, <Player>), false]
  # Called 60 times per second. Returns false if couldn't be updated, an array with :game_started as the first item and then the players, if
  # the game was started by the host, @player refreshed if the lobby got updated.
  def update
    if((Time.now - @last_update) > UPDATE_INTERVAL)
      # ask the status to the server
      @last_update = Time.now
      # we don't care if we assign [:game_started, <Player>] to @players as at that point, this instance become useless
      (response = HTTPClient.get_lobby_state(match_id: @match_id, player_id: @player_id)) ? @players = response : false
    else
      @players
    end
  end
end
