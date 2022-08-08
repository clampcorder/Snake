require 'gosu'

require './banner'
require './config'
require './dummy'
require './fruit'
require './game_over'
require './scoreboard'
require './snek_player.rb'

class SnekGame < Gosu::Window
  def initialize
    super(Config::WINDOW_X, Config::WINDOW_Y)
    @player = DummyElement.new
    @scoreboard = Scoreboard.new
    @overlay_ui = Banner.new('Press space to start')
    @fruit_manager = DummyElement.new
    @sounds = (1..3).map { |num| Gosu::Sample.new("media/beep_#{num}.wav") }.cycle
  end

  def start_game
    @play_active = true
    @player = SnekPlayer.new
    @fruit_manager = FruitManager.new
    @overlay_ui = DummyElement.new
    @scoreboard.reset
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
        death_knell = @sounds.first.play(Config::SOUND_VOLUME, 2, true)
        10.times do |x|
          death_knell.volume = Config::SOUND_VOLUME - (x * 0.05)
          death_knell.speed = 2 - (x * 0.08)
          sleep 0.08
        end
        death_knell.stop
      end

      if head_position == @fruit_manager.fruit_coordinates
        @player.grow
        @fruit_manager.spawn_fruit(@player.occupied_coordinates)
        @sounds.next.play(Config::SOUND_VOLUME)
        @scoreboard.increment
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
    if not @play_active and id == Gosu::KB_SPACE
      start_game
      return
    elsif not @play_active
      return
    elsif @player.key_bindings.include? id
      @player.handle_keypress id
    end
  end
end

SnekGame.new.show