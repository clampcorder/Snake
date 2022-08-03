require 'gosu'

require './config'
require './snek_player.rb'

class SnekGame < Gosu::Window
  def initialize
    super(Config::WINDOW_X, Config::WINDOW_Y)

    @player = SnekPlayer.new
  end

  def update
    10.times { |x| sleep 0.012 }
    @player.movement_tick

    if rand > 0.90
      @player.add_cell
    end
  end

  def draw
    @player.draw
  end

  def button_down(id)
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