require 'sqlite3'

class Scoreboard
  def initialize
    @score = 0
    @font = Gosu::Font.new(12)
    load_or_create_db
    @highscore = load_highscore_from_disk
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

  def reset
    @score = 0
  end

  def save
    if @score == @highscore
      @db.execute "INSERT INTO scores VALUES (NULL, ?);", "#{@highscore}"
    end
  end

  def increment(value=1)
    @score += value
    @highscore =[@score, @highscore].max
  end

  def draw
    @font.draw_text(
      "Score: #{@score}", 
      5,
      5,
      1,
    )
    @font.draw_text_rel(
      "Highscore: #{@highscore}",
      Config::WINDOW_X - 5,
      5,
      1,
      1,
      0,
    )
  end
end