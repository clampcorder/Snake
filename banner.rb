require 'gosu'
require './event_handler'

class Banner
  def initialize(heading, subheading='')
    @heading = heading
    @subheading = subheading
    @heading_font = Gosu::Font.new(20)
    @subheading_font = Gosu::Font.new(12)
    EventHandler.register_listener(:game_start, self, :clear)
    EventHandler.register_listener(:gameover, self, :gameover)
  end

  def clear(context)
    @heading = ""
    @subheading = ""
  end

  def gameover(context)
    @heading = "Game Over"
    @subheading = "Press space to restart"
  end

  def draw
    x = Config::WINDOW_X / 2
    y = Config::WINDOW_Y / 2

    @heading_font.draw_text_rel(
      @heading, 
      x,
      y,
      1,
      0.5,
      0.5,
    )
    
    y += @heading_font.height * 2

    @subheading_font.draw_text_rel(
      @subheading, 
      x,
      y,
      1,
      0.5,
      0.5,
    )
  end
end