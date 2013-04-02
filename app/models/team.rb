class Team < ActiveRecord::Base
  has_many :draft_picks
  has_many :players

  belongs_to :season

  has_attached_file :logo, styles: { retina: "1024x1024>", full: "512x512>", thumb: "128x128>" }

  validates_numericality_of :color,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 0xffffff

  def color_bytes
    [self.color].pack("I").bytes.reverse.drop(1)
  end

  def hex_color
    "#" + self.color_bytes.map do |color|
      color.to_s(16).rjust(2, "0")
    end.join("")
  end

  def bright
    r, g, b = *self.color_bytes.map{|x|x.to_f / 255}
    (r * 0.2126) + (g * 0.7152) + (b * 0.0722) > 0.7
  end

  def games
    Game.where('home_team_id = ? OR away_team_id = ?', self.id, self.id)
  end

  def previous_games
    self.games.where('played_on < ?', Time.now)
  end

  def next_games
    self.games.where('played_on >= ?', Time.now)
  end
end
