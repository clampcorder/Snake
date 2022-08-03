require 'gosu'

require './banner'
require './config'
require './dummy'
require './game_over'
require './snek_player.rb'

class SnekGame < Gosu::Window
  def initialize
    super(Config::WINDOW_X, Config::WINDOW_Y)
    @player = DummyElement.new
    @score_ui = DummyElement.new
    @overlay_ui = DummyElement.new
    reset_game
  end

  def reset_game
    @play_active = false
    @player = SnekPlayer.new
    @overlay_ui = DummyElement.new
  end

  def game_over
    @play_active = false
    @overlay_ui = Banner.new('Game Over')
  end

  def update
    if @play_active
      10.times { |x| sleep 0.01 }

      begin
        @player.movement_tick
      rescue
        game_over
      end

      if rand > 0.90
        @player.add_cell
      end
    end
  end

  def draw
    @player.draw
    @score_ui.draw
    @overlay_ui.draw
  end

  def button_down(id)
    if not @play_active
      reset_game
      @play_active = true
    end

    case id
    when Gosu::KB_UP
      @player.facing = :up
    when Gosu::KB_DOWN
      @player.facing = :down
    when Gosu::KB_LEFT
      @player.facing = :left
    when Gosu::KB_RIGHT
      @player.facing = :right
    else

    end
  end
end

SnekGame.new.show