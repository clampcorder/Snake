require 'gosu'

class Banner
  def initialize(message)
    @message = message
    @font = Gosu::Font.new(20)
  end

  def draw
    @font.draw_text(@message, Config::WINDOW_X / 2, Config::WINDOW_Y / 2, 1)
  end
end