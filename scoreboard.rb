require 'sqlite3'
require './event_handler'

class Scoreboard
  def initialize
    @scores = {1 => 0, 2 => 0}
    @font = Gosu::Font.new(16)
    # load_or_create_db
    # @highscore = load_highscore_from_disk

    EventHandler.register_listener(:fruit_eaten, self, :increment)
    # EventHandler.register_listener(:gameover, self, :save)
    EventHandler.register_listener(:game_start, self, :reset)
  end

  def load_or_create_db
    @db = SQLite3::Database.new("scores.db")
    begin
      @db.execute "SELECT * FROM scores LIMIT 1;"
    rescue SQLite3::SQLException
      @db.execute "CREATE TABLE scores (name varchar(64), score int);"
      @db.execute "INSERT INTO scores VALUES (NULL, 0);"
    end
  end

  def load_highscore_from_disk
    @highscore = @db.get_first_value "SELECT score from scores ORDER BY score DESC LIMIT 1"
  end

  def reset(context)
    @scores = {1=> 0, 2=> 2}
  end

  def save(context)
    if @score == @highscore
      @db.execute "INSERT INTO scores VALUES (NULL, ?);", "#{@highscore}"
    end
  end

  def increment(context)
    @scores[context[:player]] += context[:points]
  end

  def draw
    @font.draw_text_rel(
      "Player 1: #{@scores[1]}",
      5,
      5,
      0,
      0,
      0,
      1,
      1,
      Gosu::Color::AQUA,
    )
    @font.draw_text_rel(
      "Player 2: #{@scores[2]}",
      Config::WINDOW_X - 5,
      5,
      1,
      1,
      0,
      1,
      1,
      Gosu::Color::RED,
    )
  end
end