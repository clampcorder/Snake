require 'set'

require './config'
require './game_over'

class SnekPlayer

  attr_writer :facing

  def initialize
    @facing = nil
    @initial_color = Gosu::Color::AQUA.dup

    @visible_cells = [Cell.new(Config::WINDOW_X / 2, Config::WINDOW_Y / 2, @initial_color)]
    @occupied_coordinates = Set.new
    @occupied_coordinates.add [@visible_cells[0].x, @visible_cells[0].y]
  end

  def next_cell_position(x, y, facing)
    case facing
    when :up
      y -= 10
    when :down
      y += 10
    when :left
      x -= 10
    when :right
      x += 10
    else
      
    end
    x %= Config::WINDOW_X
    y %= Config::WINDOW_Y
    return x, y
  end

  def movement_tick
    head = @visible_cells.first
    tail = @visible_cells.last
    x, y = next_cell_position(head.x, head.y, @facing)
    if @occupied_coordinates.include? [x, y]
      raise GameOver
    end

    color = head.color.dup
    @visible_cells = [Cell.new(x, y, color)] + @visible_cells[0..-2]
    @occupied_coordinates.add [x, y]
    @occupied_coordinates.delete [tail.x, tail.y]
  end

  def add_cell
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
    @image.draw(@x, @y, 0, 1, 1, @color)
  end

  def advance_hue
    @color.hue = (@color.hue + 5) % 360
  end
end