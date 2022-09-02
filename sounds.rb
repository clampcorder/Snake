require 'gosu'
require './config'
require './event_handler'

class SoundManager
  def initialize
    @beeps = (1..3).map do |num|
       Gosu::Sample.new("media/beep_#{num}.wav")
    end.cycle
    @pause = Gosu::Sample.new("media/double_up.wav")
    @unpause = Gosu::Sample.new("media/double_down.wav")

    EventHandler.register_listener(:fruit_eaten, self, :happy_beep)
    EventHandler.register_listener(:gameover, self, :death_knell)
    EventHandler.register_listener(:game_paused, self, :pause)
    EventHandler.register_listener(:game_unpaused, self, :unpause)
  end

  def death_knell(context)
    beep = @beeps.first.play(Config::SOUND_VOLUME, 2, true)
    10.times do |x|
      beep.volume = Config::SOUND_VOLUME - (x * 0.05)
      beep.speed = 2 - (x * 0.08)
      sleep 0.08
    end
    beep.stop
  end

  def happy_beep(context)
    @beeps.next.play(Config::SOUND_VOLUME)
  end

  def pause(context)
    @pause.play(Config::SOUND_VOLUME)
  end

  def unpause(context)
    @unpause.play(Config::SOUND_VOLUME)
  end
end