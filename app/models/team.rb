class Team < ActiveRecord::Base
  has_many :draft_picks
  has_many :players
  has_many :substitutions
  has_many :trades

  belongs_to :season
  
  before_save :sluggify

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

  def brightness
    r, g, b = *self.color_bytes.map{|x|x.to_f / 255}
    (r * 0.2126) + (g * 0.7152) + (b * 0.0722)
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

  def sluggify
    self.slug = self.name.parameterize
  end

  def to_param
    self.slug
  end

  def update_points
    reset_stats!
    self.games.each do |game|
      home = game.home_team_id == self.id
      overtime = game.overtime
      if game.home_score > game.away_score
        if overtime
          self.points += home ? 2 : 1
          self.overtime_wins += 1 if home
          self.overtime_losses += 1 unless home
        else
          self.points += home ? 3 : 0
          self.wins += 1 if home
          self.losses += 1 unless home
        end
      elsif game.home_score < game.away_score
        if overtime
          self.points += home ? 1 : 2
          self.overtime_wins += 1 unless home
          self.overtime_losses += 1 if home
        else
          self.points += home ? 0 : 3
          self.wins += 1 unless home
          self.losses += 1 if home
        end
      else
        self.points += 1
        self.ties += 1
      end
    end
    self.save
  end

  private
  def reset_stats!
    self.points = 0
    self.wins = 0
    self.losses = 0
    self.overtime_wins = 0
    self.overtime_losses = 0
    self.ties = 0
  end
end
