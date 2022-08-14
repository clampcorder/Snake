class FruitManager
  attr_reader :fruit_coordinates

  def initialize
    @image = Gosu::Image.new("media/cell.bmp")
    x_values = (0...Config::Window::WIDTH / 10).map { |x| x * 10}
    y_values = (0...Config::Window::HEIGHT / 10).map { |x| x * 10}
    @candidate_coordinates = x_values.product(y_values).to_set
    spawn_fruit []
  end

  def spawn_fruit(occupied_coordinates)
    possible_coordinates = (@candidate_coordinates - occupied_coordinates.to_set).to_a
    @fruit_coordinates = *(possible_coordinates.sample)

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