class ObjectiveManager
  attr_reader :objective_coordinates

  def initialize
    @image = Gosu::Image.new("media/cell.bmp")
    x_values = (0...Config::WINDOW_X / 10).map { |x| x * 10}
    y_values = (0...Config::WINDOW_Y / 10).map { |x| x * 10}
    @candidate_coordinates = x_values.product(y_values).to_set
    @objective_type = :fruit
    spawn_objective []
  end

  def spawn_objective(occupied_coordinates)
    possible_coordinates = (@candidate_coordinates - occupied_coordinates.to_set).to_a
    @objective_coordinates = *(possible_coordinates.sample)
    @objective_type = rand() <= 0.05 ? :mouse : :fruit

    if @objective_type == :fruit
      @color = Gosu::Color.new(
        rand(200..256),
        rand(128..256),
        rand(64..128),
      )
    elsif @objective_type == :mouse
      @color = Gosu::Color::GRAY
    end

  end

  def update
    return unless @objective_coordinates
    return unless @objective_type == :mouse
    if rand() <= 0.25
      axis_index = [0, 1].sample
      magnitude = [-10, 10].sample
      @objective_coordinates[axis_index] += magnitude
    end
  end

  def draw
    x, y = *@objective_coordinates
    @image.draw(x, y, 0, 1, 1, @color)
  end
end