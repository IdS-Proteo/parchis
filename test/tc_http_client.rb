require 'minitest/autorun'
require_relative '../lib/parchis/http_client'

class TestHTTPClient < MiniTest::Test

  def setup
    @http_client = HTTPClient.new()
  end
   
  def test_get_new_match_id
    #to be implemented
  end

  def test_get_match_lobby_existence
    #to be implemented
  end

  def test_post_joining_to_lobby
    #to be implemented
  end

  def test_post_leaving_lobby
    #to be implemented
  end

  def test_get_lobby_state
    #to be implemented
  end

  def test_post_match
    #to be implemented
  end

  def test_post_match_started
    #to be implemented
  end

  def test_get_player_turn
    #to be implemented
  end

  def test_get_game_last_events
    #to be implemented
  end

  def test_post_dice_rolled
    #to be implemented
  end

  def test_post_token_moved
    #to be implemented
  end

  def test_post_match_quit
    #to be implemented
  end
    
end