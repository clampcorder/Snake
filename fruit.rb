class FruitManager
  attr_reader :fruit_coordinates

  def initialize
    @image = Gosu::Image.new("media/cell.bmp")
    spawn_fruit
  end

  def spawn_fruit
    x = rand(Config::WINDOW_X / 10) * 10
    y = rand(Config::WINDOW_Y / 10) * 10
    @fruit_coordinates = [x, y]
    @color = Gosu::Color.new(
      rand(128..256),
      rand(128..256),
      rand(128..256),
    )
  end

  def draw
    x, y = *@fruit_coordinates
    @image.draw(x, y, 0, 1, 1, @color)
  end
end