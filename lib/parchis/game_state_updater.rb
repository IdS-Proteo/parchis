# An instance of this class keeps the game updated.
class GameStateUpdater

  UPDATE_INTERVAL = 2.75 # seconds

  # @param match_id [String]
  # @param player_id [Integer]
  # @param board [Board]
  # @param dice [Dice]
  # @param players [Array<Player>]
  # @param rolling_dice_sfx [Gosu::Sample]
  # Constructor.
  def initialize(match_id:, player_id:, board:, dice:, players:, rolling_dice_sfx:)
    @events_processed = {}
    @match_id = match_id
    @last_update = Time.now
    @board = board
    @dice = dice
    @players = players
    @rolling_dice_sfx = rolling_dice_sfx
  end

  # @param event_id [Integer]
  # @param event [String, nil] event in the coded form, i.e.: "rA3t"
  def event_processed(event_id:, event: nil)
    @events_processed[event_id] = (event || true)
  end

  def leave_game
    HTTPClient.post_match_quit(match_id: @match_id, player_id: @player_id)
  end

  # @return [Boolean] false if couldn't update, true otherwise.
  # Called 60 times per second.
  def update
    # update the delayed events
    Delayer.update()
    # next code gets executed only once in a while
    if((Time.now - @last_update) > UPDATE_INTERVAL)
      @last_update = Time.now
      # retrieve last game events
      if(last_events = HTTPClient.get_game_last_events(match_id: @match_id))
        last_events.each do |event|
          # each event looks like {'ev' => 'dr4', 'id' => 51}
          if(!@events_processed.has_key?(event['id']))
            # process this event now
            code = event['ev'] #: String
            case code[0..1]
              when 'dr'
                # dice roll event
                @rolling_dice_sfx.play()
                roll_value = code[-1].to_i
                @dice.force_last_roll(value: roll_value)
                @board.dice_rolled(result: roll_value)
              when 'tm'
                # token moved event, but it could be just an end of turn event
                if((cells_to_move = code[4].to_i) != 0)
                  player = nil
                  @players.each do |_player|
                    next if !_player
                    if(_player.color.to_s.[](0) == code[2])
                      player = _player
                      break
                    end
                  end
                  @board.perform_move(token_label: code[3], cells_to_move: cells_to_move, player: player)
                end
                # if it's the end of the turn, make it happen
                if(code[-1] == 't')
                  # delay the dice change of state to "?" and next turn
                  Delayer.new(GameStateUpdater::UPDATE_INTERVAL) {@board.next_turn(); @dice.set_unknown_state()}
                end
              when 'pq'
                # player quitted event
                @board.player_quitted(player_id: code[-1].to_i)
            end
            # register that this event was processed
            event_processed(event_id: event['id'], event: code)
          end
        end
      else
        return false
      end
    end
    true
=begin
  rescue => e
    warn("Error: #{e.class}.")
    warn("Message: #{e.message}.")
    false
=end
  end
end
