require 'gosu'

class Background

  def initialize
    @image = Gosu::Image.new("media/cell.bmp", :tileable=>true)
    @outer_color = Gosu::Color.argb(0xff_202020)
    @border_color = Gosu::Color::WHITE
    @inner_color = Gosu::Color::BLACK
  end

  def draw
    @image.draw(
      0, 0, 
      0, 
      Config::WINDOW_X * Config::CELL_SCALE, 
      Config::WINDOW_Y * Config::CELL_SCALE, 
      @outer_color
    )
    @image.draw(
      (Config::OFFSET_X - 1), 
      (Config::OFFSET_Y - 1), 
      0, 
      (Config::CELLS_WIDTH * Config::CELL_SCALE) + 0.2, 
      (Config::CELLS_HEIGHT * Config::CELL_SCALE) + 0.2, 
      @border_color,
    )
    @image.draw(
      (Config::OFFSET_X), 
      (Config::OFFSET_Y), 
      0, 
      (Config::CELLS_WIDTH * Config::CELL_SCALE), 
      (Config::CELLS_HEIGHT * Config::CELL_SCALE), 
      @inner_color,
    )
    #@image.draw(0, 0, 2, Config::WINDOW_X, Config::WINDOW_Y, @outer_color)
  end
end