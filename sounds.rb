require 'gosu'
require './config'

class SoundManager
  def initialize
    @beeps = (1..3).map do |num|
       Gosu::Sample.new("media/beep_#{num}.wav")
    end.cycle
    @pausing = Gosu::Sample.new("media/double_up.wav")
    @unpausing = Gosu::Sample.new("media/double_down.wav")
  end

  def death_knell
    beep = @beeps.first.play(Config::SOUND_VOLUME, 2, true)
    10.times do |x|
      beep.volume = Config::SOUND_VOLUME - (x * 0.05)
      beep.speed = 2 - (x * 0.08)
      sleep 0.08
    end
    beep.stop
  end

  def happy_beep
    @beeps.next.play(Config::SOUND_VOLUME)
  end

  def pause_toggled(is_paused)
    if is_paused
      @pausing.play(Config::SOUND_VOLUME)
    else
      @unpausing.play(Config::SOUND_VOLUME)
    end
  end
end