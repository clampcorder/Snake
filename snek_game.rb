require 'gosu'

require './banner'
require './config'
require './dummy'
require './fruit'
require './game_over'
require './objective'
require './scoreboard'
require './snek_player.rb'
require './sounds'

class SnekGame < Gosu::Window
  def initialize
    super(Config::WINDOW_X, Config::WINDOW_Y)
    @game_in_progress = false
    @paused = false
    @player = DummyElement.new
    @scoreboard = Scoreboard.new
    @overlay_ui = Banner.new('Press space to start')
    @sound_manager = SoundManager.new
    @objective_manager = DummyElement.new
  end

  def start_game
    @game_in_progress = true
    @player = SnekPlayer.new
    @fruit_manager = FruitManager.new
    @objective_manager = ObjectiveManager.new
    @overlay_ui = DummyElement.new
    @scoreboard.reset
    return
  end

  def game_over
    @game_in_progress = false
    @overlay_ui = Banner.new('Game Over', 'Press space to restart')
    @scoreboard.save
  end

  def update
    if @game_in_progress and not @paused
      6.times { |x| sleep 0.01 }

      begin
        head_position = @player.movement_tick
      rescue
        game_over
        @sound_manager.death_knell
      end

      if head_position == @objective_manager.objective_coordinates
        @player.grow
        @objective_manager.spawn_objective(@player.occupied_coordinates)
        @sound_manager.happy_beep
        @scoreboard.increment
      end

      @objective_manager.update

    end
  end

  def draw
    @player.draw
    #@fruit_manager.draw
    @objective_manager.draw
    @scoreboard.draw
    @overlay_ui.draw
  end

  def button_down(id)
    if not @game_in_progress and id == Gosu::KB_SPACE
      start_game
      return
    elsif not @game_in_progress
      return
    elsif not @paused and @player.key_bindings.include? id
      @player.handle_keypress id
    elsif @game_in_progress and id == Gosu::KB_P
      @paused = (not @paused)
    end
  end
end

SnekGame.new.show