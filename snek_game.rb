require 'gosu'

require './banner'
require './config'
require './dummy'
require './fruit'
require './game_over'
require './snek_player.rb'

class SnekGame < Gosu::Window
  def initialize
    super(Config::WINDOW_X, Config::WINDOW_Y)
    @player = DummyElement.new
    @score_ui = DummyElement.new
    @overlay_ui = Banner.new('Press space to start')
    @fruit_manager = DummyElement.new
  end

  def start_game
    @play_active = true
    @player = SnekPlayer.new
    @fruit_manager = FruitManager.new
    @overlay_ui = DummyElement.new
    return
  end

  def game_over
    @play_active = false
    @overlay_ui = Banner.new('Game Over', 'Press space to restart')
  end

  def update
    if @play_active
      6.times { |x| sleep 0.01 }

      begin
        head_position = @player.movement_tick
      rescue
        game_over
      end

      if head_position == @fruit_manager.fruit_coordinates
        @player.grow
        @fruit_manager.spawn_fruit(@player.occupied_coordinates)
      end

    end
  end

  def draw
    @player.draw
    @fruit_manager.draw
    @score_ui.draw
    @overlay_ui.draw
  end

  def button_down(id)
    if not @play_active and id == Gosu::KB_SPACE
      reset_game
      start_game
      return
    end

    if @player.key_bindings.include? id
      @player.handle_keypress id
    end
  end
end

SnekGame.new.show