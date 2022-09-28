require 'gosu'

module Config
  CELL_SIZE = 16
  CELLS_WIDTH = 20
  CELLS_HEIGHT = 20
  OFFSET_X = 64
  OFFSET_Y = 32
  INITIAL_SIZE = 2
  FULLSCREEN = true

  SOUND_VOLUME = 0.25

  KEY_BINDINGS = [
    Gosu::KB_UP,
    Gosu::KB_DOWN,
    Gosu::KB_LEFT,
    Gosu::KB_RIGHT,
  ]

  # Speeds are represented as delays between frames in milliseconds.
  # beyond the window's update interval
  SPEEDS = {
    :slow => 50,
    :medium => 35,
    :fast => 25,
    :ludicrous => 15,
  }

  # Derived values
  CELL_SCALE = CELL_SIZE.fdiv 10
  TEMPORAL_SCALE = (CELL_SCALE + 2).fdiv 3
  WINDOW_X = (CELL_SIZE * CELLS_WIDTH) + 2 * OFFSET_X
  WINDOW_Y = (CELL_SIZE * CELLS_HEIGHT) + 2 * OFFSET_Y

end