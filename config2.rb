require 'singleton'

class Config2
  include Singleton
  attr_reader :*

  @WINDOW_HEIGHT = 300
  @WINDOW_WIDTH = 400

  @SOUND_VOLUME = 0.25

  def initialize
    @WINDOW_HEIGHT = 600
    @WINDOW_WIDTH = 800
  end
end