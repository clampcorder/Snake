class Scoreboard
  def initialize
    @score = 0
    @highscore = 0
    @font = Gosu::Font.new(12)
  end

  def reset
    @score = 0
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
  end
end