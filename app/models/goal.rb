class Goal < ActiveRecord::Base
  belongs_to :game
  belongs_to :team
  belongs_to :scorer, class_name: :Player
  belongs_to :first_assist, class_name: :Player
  belongs_to :second_assist, class_name: :Player

  after_create :update_scores

  before_save :readable_time_to_time

  before_destroy :decrement_scores

  # after-MR validations
  validates_presence_of :scorer, if: :reported?
  validates_presence_of :scored_against, if: :reported?
  validates_presence_of :team, if: :reported?

  validate :correct_players, if: :reported?

  # during-MR validations
  validates_numericality_of :time, greater_than_or_equal_to: 0
  validates_inclusion_of :half, in: 1..3, message: "isn't a valid half"

  scope :by_time, -> { order(:half, :time) }

  def reported?
    Game.find(self.game_id).reported?
  end

  def readable_time
    m, s = *self.time.divmod(60)
    "#{m}:#{s.to_s.rjust(2, "0")}"
  end

  def readable_time= str
    @readable_time = str
  end

  private
  def readable_time_to_time
    m, s = *(@readable_time || "0:00").split(":").map(&:to_i)
    upper_limit = (self.half ||= 1) > 2 ? 99 : 5
    if !m.between?(0, upper_limit)
      errors.add :time,
        "must be between 0 and #{upper_limit} minutes (except in OT)."
      false
    elsif !s.between?(0, 59)
      errors.add :time, "must be a valid number of seconds."
      false
    else
      self.time = m * 60 + s
      true
    end
  end

  def correct_players
    g = self.game
    unless g.home_team == self.team || g.away_team == self.team
      errors.add_to_base "Must be scored by a player actually in the game."
    end
  end

  def update_scores
    home = self.team == self.game.home_team
    if home
      self.game.home_score += 1
    else
      self.game.away_score += 1
    end
    self.game.save
  end

  def decrement_scores
    home = self.team == self.game.home_team
    if home
      self.game.home_score -= 1
    else
      self.game.away_score -= 1
    end
    self.game.save
  end
end
