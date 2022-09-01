require './event_handler'

class FruitManager
  attr_reader :fruit_coordinates

  def initialize
    @image = Gosu::Image.new("media/cell.bmp")
    @color = random_color
    x_values = (0...Config::CELLS_WIDTH).map { |x| x * Config::CELL_SIZE}
    y_values = (0...Config::CELLS_HEIGHT).map { |x| x * Config::CELL_SIZE}
    @candidate_coordinates = x_values.product(y_values).to_set
    @occupied_coordinates = Set.new
    @fruit_coordinates = [-1000, -1000]
    EventHandler.register_listener(:fruit_eaten,  self, :spawn_fruit)
    EventHandler.register_listener(:game_start,   self, :spawn_fruit)
    EventHandler.register_listener(:cell_entered, self, :cell_entered)
    EventHandler.register_listener(:cell_exited,  self, :cell_exited)
    EventHandler.register_listener(:cell_entered, self, :check_fruit_eaten)
  end

  def check_fruit_eaten(context)
    if context[:coordinates] == @fruit_coordinates then
      EventHandler.publish_event(:fruit_eaten, {:points => 1})
    end
  end

  def cell_entered(context)
    @occupied_coordinates.add context[:coordinates]
  end

  def cell_exited(context)
    @occupied_coordinates.delete context[:coordinates]
  end

  def spawn_fruit(context)
    possible_coordinates = (@candidate_coordinates - @occupied_coordinates.to_set).to_a
    @fruit_coordinates = *(possible_coordinates.sample)
    @color = random_color
  end

  def random_color
    Gosu::Color.new(
      rand(128..256),
      rand(128..256),
      rand(128..256),
    )
  end

  def draw
    x, y = *@fruit_coordinates
    x = x + Config::OFFSET_X
    y = y + Config::OFFSET_Y
    @image.draw(x, y, 1, Config::CELL_SCALE, Config::CELL_SCALE, @color)
  end
end