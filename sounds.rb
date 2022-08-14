require 'gosu'
require './config'

class SoundManager
  def initialize
    @sounds = (1..3).map do |num|
       Gosu::Sample.new("media/beep_#{num}.wav")
    end.cycle
  end

  def death_knell
    beep = @sounds.first.play(Config::Sound::VOLUME, 2, true)
    10.times do |x|
      beep.volume = Config::Sound::VOLUME - (x * 0.05)
      beep.speed = 2 - (x * 0.08)
      sleep 0.08
    end
    beep.stop
  end

  def happy_beep
    @sounds.next.play(Config::Sound::VOLUME)
  end
end