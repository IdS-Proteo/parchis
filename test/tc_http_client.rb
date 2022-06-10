require 'minitest/autorun'
require 'minitest/junit'
require_relative '../lib/parchis/http_client'

class TestHTTPClient < MiniTest::Test

  def setup
    @http_client = HTTPClient.new()
  end
   
  def test_get_new_match_id
    #assert_equal [true,"1234567890"],@http_client.get_new_match_id
  end

  def test_get_match_lobby_existence
    #assert_equal [0,nil],@http_client.get_match_lobby_existence('1234567890')
  end

  def test_post_joining_to_lobby
      
  end

  def test_post_leaving_lobby

  end

  def test_get_lobby_state

  end

  def test_post_match

  end

  def test_post_match_started

  end

  def test_get_player_turn

  end

  def test_post_match_quit

  end
    
end