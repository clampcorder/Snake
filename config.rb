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

  PLAYER_1_BINDINGS = {
    :up => Gosu::KB_UP,
    :down => Gosu::KB_DOWN,
    :left => Gosu::KB_LEFT,
    :right => Gosu::KB_RIGHT,
  }

  PLAYER_2_BINDINGS = {
    :up => Gosu::KB_W,
    :down => Gosu::KB_S,
    :left => Gosu::KB_A,
    :right => Gosu::KB_D,
  }

  # Derived values
  CELL_SCALE = CELL_SIZE.fdiv 10
  TEMPORAL_SCALE = (CELL_SCALE + 2).fdiv 3
  WINDOW_X = (CELL_SIZE * CELLS_WIDTH) + 2 * OFFSET_X
  WINDOW_Y = (CELL_SIZE * CELLS_HEIGHT) + 2 * OFFSET_Y
  ALL_BOUND_KEYS = PLAYER_1_BINDINGS.values + PLAYER_2_BINDINGS.values
end