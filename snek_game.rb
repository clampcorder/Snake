require 'gosu'

require './background'
require './banner'
require './config'
require './dummy'
require './fruit'
require './scoreboard'
require './snek_player'
require './sounds'

class SnekGame < Gosu::Window
  def initialize
    super(Config::WINDOW_X, Config::WINDOW_Y)
    @game_state = :stopped
    @sound_manager = SoundManager.new
    @player = SnekPlayer.new
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
    @game_state = :unpaused
  end

  def gameover(context)
    EventHandler.publish_event(:gameover, context)
    @game_state = :stopped
  end

  def update
    if @game_state == :playing
      6.times { |x| sleep(0.01 * Config::TEMPORAL_SCALE) }
      @player.handle_keypress @input_buffer.pop if not @input_buffer.empty?
      @player.movement_tick
    end
  end

  def draw
    @background.draw
    @player.draw
    @fruit_manager.draw
    @scoreboard.draw
    @overlay_ui.draw
  end

  def button_down(id)
    if @game_state == :stopped and id == Gosu::KB_SPACE
      EventHandler.publish_event(:game_start)
    elsif @game_state == :playing and id == Gosu::KB_SPACE
      EventHandler.publish_event(:paused)
    elsif @game_state == :paused and id == Gosu::KB_SPACE
      EventHandler.publish_event(:unpaused)
    elsif @game_state == :playing and Config::KEY_BINDINGS.include? id
      @input_buffer << id
    end
  end
end

SnekGame.new.show