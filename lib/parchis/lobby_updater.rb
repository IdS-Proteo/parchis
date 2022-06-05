# An instance of this class keeps the lobby updated.
class LobbyUpdater

  # @param players [Array<Player>]
  # @param match_id [String]
  # @param player_id [Integer], 0..3
  def initialize(players:, match_id:, player_id:)
    @players = players
    @match_id = match_id
    @player_id = player_id
  end

  # Joins the lobby with @match_id. Previously to this call, a check is supposed to be made for slot.
  def join_lobby
    HTTPClient.post_joining_to_lobby(match_id: @match_id, player: @players[@player_id])
  end
end