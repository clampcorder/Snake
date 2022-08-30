require 'gosu'

require './banner'
require './config'
require './dummy'
require './fruit'
require './scoreboard'
require './snek_player.rb'
require './sounds'

class SnekGame < Gosu::Window
  def initialize
    super(Config::WINDOW_X, Config::WINDOW_Y)
    @game_in_progress = false
    @paused = false
    @sound_manager = SoundManager.new
    @player = SnekPlayer.new
    @scoreboard = Scoreboard.new
    @overlay_ui = Banner.new('Press space to start')
    @fruit_manager = FruitManager.new
    @input_buffer = Queue.new
    EventHandler.register_listener(:snake_died, self, :gameover)
    EventHandler.register_listener(:game_start, self, :start_game)
  end

  def start_game(context)
    @game_in_progress = true
  end

  def gameover(context)
    EventHandler.publish_event(:gameover, context)
    @game_in_progress = false
  end

  def update
    if @game_in_progress and not @paused
      6.times { |x| sleep 0.01 }
      @player.handle_keypress @input_buffer.pop if not @input_buffer.empty?

      head_position = @player.movement_tick

      if head_position == @fruit_manager.fruit_coordinates
        context = {
          :points => 1,
          :occupied_coordinates => @player.occupied_coordinates
        }
        EventHandler.publish_event(:fruit_eaten, context)
      end

    end
  end

  def draw
    @player.draw
    @fruit_manager.draw
    @scoreboard.draw
    @overlay_ui.draw
  end

  def button_down(id)
    if not @game_in_progress and id == Gosu::KB_SPACE
      EventHandler.publish_event(:game_start, {:occupied_coordinates => []})
      return
    elsif not @game_in_progress
      return
    elsif not @paused and Config::KEY_BINDINGS.include? id
      @input_buffer << id
    elsif @game_in_progress and id == Gosu::KB_P
      @paused = (not @paused)
      @sound_manager.pause_toggled(@paused)
    end
  end
end

SnekGame.new.show