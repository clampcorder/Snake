require 'set'

require './config'
require './event_handler'

class SnekPlayer
  def initialize(is_player_1)
    @facing = is_player_1 ? :right : :left
    @last_calculated_facing = is_player_1 ? :right : :left
    @bindings = is_player_1 ? Config::PLAYER_1_BINDINGS : Config::PLAYER_2_BINDINGS
    @initial_color = is_player_1 ? Gosu::Color::AQUA.dup : Gosu::Color::RED.dup

    EventHandler.register_listener(:fruit_eaten, self, :grow)
    EventHandler.register_listener(:game_start, self, :reset)

    # Required in initializer so that `draw` works on first draw
    reset({})
  end

  def reset(context)
    @visible_cells = [
      Cell.new(
        Config::CELL_SIZE * Config::CELLS_WIDTH / 2,
        Config::CELL_SIZE * Config::CELLS_HEIGHT / 2,
        @initial_color)
    ]
    @occupied_coordinates = Set.new
    @occupied_coordinates.add [@visible_cells[0].x, @visible_cells[0].y]
    [Config::INITIAL_SIZE, 0].max.times { grow({}) }
  end

  def handle_keypress(id)
    # Change the facing direction of the head, do not allow going directly opposite
    # current direction, or else player instantly dies.
    return if id == nil

    case id
    when @bindings[:up]
      @facing = :up unless @last_calculated_facing == :down
    when @bindings[:down]
      @facing = :down unless @last_calculated_facing == :up
    when @bindings[:left]
      @facing = :left unless @last_calculated_facing == :right
    when @bindings[:right]
      @facing = :right unless @last_calculated_facing == :left
    else

    end

  end

  def next_cell_position(x, y, facing)
    case facing
    when :up
      y -= Config::CELL_SIZE
    when :down
      y += Config::CELL_SIZE
    when :left
      x -= Config::CELL_SIZE
    when :right
      x += Config::CELL_SIZE
    else
      
    end
    x %= Config::CELL_SIZE * Config::CELLS_WIDTH
    y %= Config::CELL_SIZE * Config::CELLS_HEIGHT
    return x, y
  end

  def movement_tick
    @last_calculated_facing = @facing
    head = @visible_cells.first
    tail = @visible_cells.last
    x, y = next_cell_position(head.x, head.y, @facing)
    if @occupied_coordinates.include? [x, y]
      EventHandler.publish_event(:snake_died)
    end

    color = head.color.dup
    @visible_cells = [Cell.new(x, y, color)] + @visible_cells[0..-2]
    @occupied_coordinates.add [x, y]
    @occupied_coordinates.delete [tail.x, tail.y]

    EventHandler.publish_event(:cell_entered, {:coordinates => [x, y]})
    EventHandler.publish_event(:cell_exited,  {:coordinates => [tail.x, tail.y]})
  end

  def grow(context)
    last_cell = @visible_cells.last
    next_cell = last_cell.dup
    @visible_cells.append next_cell
    @occupied_coordinates.add [next_cell.x, next_cell.y]
  end

  def draw
    color = @initial_color.dup
    @visible_cells.each do |cell|
      cell.color = color
      color.hue = (color.hue + 5) % 360
      cell.draw
    end
  end
end


class Cell
  attr_accessor :x, :y, :color

  def initialize(x, y, color)
    @x = x
    @y = y
    @color = color
    @image = Gosu::Image.new("media/cell.bmp")
  end

  def dup
    Cell.new(@x, @y, @color.dup)
  end

  def draw
    x = @x + Config::OFFSET_X
    y = @y + Config::OFFSET_Y
    @image.draw(
      x, y,
      1,
      Config::CELL_SCALE, Config::CELL_SCALE,
      @color
    )
  end

  def advance_hue
    @color.hue = (@color.hue + 5) % 360
  end
end