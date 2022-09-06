require 'gosu'

require './background'
require './banner'
require './config'
require './fruit'
require './scoreboard'
require './snek_player'
require './sounds'

class SnekGame < Gosu::Window
  def initialize
    super(Config::WINDOW_X, Config::WINDOW_Y, Config::FULLSCREEN)
    @game_state = :stopped
    @sound_manager = SoundManager.new
    @players = [SnekPlayer.new(true), SnekPlayer.new(false)]
    @scoreboard = Scoreboard.new
    @overlay_ui = Banner.new('Press space to start')
    @fruit_manager = FruitManager.new
    @background = Background.new
    @input_buffer = Queue.new
    EventHandler.register_listener(:snake_died, self, :gameover)
    EventHandler.register_listener(:game_start, self, :game_start)
    EventHandler.register_listener(:game_paused, self, :game_paused)
    EventHandler.register_listener(:game_unpaused, self, :game_unpaused)
  end

  def game_start(context)
    @game_state = :playing
  end

  def game_paused(context)
    @game_state = :paused
  end

  def game_unpaused(context)
    @game_state = :playing
  end

  def gameover(context)
    EventHandler.publish_event(:gameover, context)
    @game_state = :stopped
  end

  def update
    if @game_state == :playing
      6.times { |x| sleep(0.01 * Config::TEMPORAL_SCALE) }
      next_key = @input_buffer.pop if not @input_buffer.empty?
      @players[0].handle_keypress next_key
      @players[0].movement_tick
      @players[1].handle_keypress next_key
      @players[1].movement_tick
    end
  end

  def draw
    @background.draw
    @players[0].draw
    @players[1].draw
    @fruit_manager.draw
    @scoreboard.draw
    @overlay_ui.draw
  end

  def button_down(id)
    if @game_state == :stopped and id == Gosu::KB_SPACE
      EventHandler.publish_event(:game_start)
    elsif @game_state == :playing and id == Gosu::KB_SPACE
      EventHandler.publish_event(:game_paused)
    elsif @game_state == :paused and id == Gosu::KB_SPACE
      EventHandler.publish_event(:game_unpaused)
    elsif @game_state == :playing and Config::ALL_BOUND_KEYS.include? id
      # bit odd to share the same buffer for both snakes... but this should actually work
      # cause each snake will only react to its bound keys, so just send to both
      @input_buffer << id
    end
  end
end

SnekGame.new.show