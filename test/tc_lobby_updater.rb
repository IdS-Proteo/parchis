require 'minitest/autorun'
require_relative '../lib/parchis/lobby_updater'

class TestLobbyUpdater < MiniTest::Test

  UPDATE_INTERVAL = 2.75
  def setup
    @lobby_updater = LobbyUpdater.new(players:['player1', 'player2', 'player3', 'player4'], match_id:'1234567890', player_id:0)
  end
    
  def test_join_lobby
    #to be implemented
  end

  def test_leave_lobby
    #to be implemented
  end

  def test_update
    #to be implemented
  end

end