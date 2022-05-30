# core libraries
require 'net/http'
require 'json'

# external libraries
require 'gosu'

# source code
require_relative 'parchis/parchis'
require_relative 'parchis/cell'
require_relative 'parchis/board'
require_relative 'parchis/player'
require_relative 'parchis/token'
require_relative 'parchis/http_client'

# initialize app
Parchis.new.show()
