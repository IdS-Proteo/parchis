# core libraries
require 'net/http'
require 'uri'
require 'json'

# external libraries
require 'gosu'

# source code
require_relative 'parchis/seven_faces_dice'
require_relative 'parchis/six_faces_dice'
require_relative 'parchis/dice'
require_relative 'parchis/parchis'
require_relative 'parchis/cell'
require_relative 'parchis/board'
require_relative 'parchis/player'
require_relative 'parchis/token'
require_relative 'parchis/http_client'
require_relative 'parchis/v_widget'
require_relative 'parchis/v_actions'
require_relative 'parchis/v_countdown'
require_relative 'parchis/v_stats'
require_relative 'parchis/v_current_turn'
require_relative 'parchis/v_tips'
require_relative 'parchis/game_state_updater'
require_relative 'parchis/lobby_updater'
require_relative 'parchis/delayer'

# initialize app
parchis = Parchis.new
parchis.show()
# make sure we let the server know we're leaving
at_exit do
  case parchis.phase.first
    when 2
      parchis.lobby_updater.leave_lobby()
    when 3
      parchis.game_state_updater.leave_game()
  end
end
