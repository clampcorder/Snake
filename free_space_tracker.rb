require './event_handler'

class FreeSpaceTracker

  def initialize()
    @occupied_coordinates = Set.new
    EventHandler.register_listener(:cell_entered, self, :free_space_mark_cell_entered)
    EventHandler.register_listener(:cell_exited,  self, :free_space_mark_cell_exited)
    EventHandler.register_listener(:game_start,   self, :free_space_reset)
  end

  def free_space_reset(context)
    @occupied_coordinates = Set.new
  end

  def free_space_mark_cell_entered(context)
    @occupied_coordinates.add context[:coordinates]
  end

  def free_space_mark_cell_exited(context)
    @occupied_coordinates.delete context[:coordinates]
  end

end