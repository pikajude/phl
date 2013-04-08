class Goal < ActiveRecord::Base
  belongs_to :game
  belongs_to :team
  belongs_to :scorer, class_name: :Player
  belongs_to :first_assist, class_name: :Player
  belongs_to :second_assist, class_name: :Player

  after_create :update_scores

  before_destroy :decrement_scores

  # after-MR validations
  validates_presence_of :scorer, if: :reported?
  validates_presence_of :scored_against, if: :reported?
  validates_presence_of :team, if: :reported?

  validate :correct_players, if: :reported?

  # during-MR validations
  validates_numericality_of :time, greater_than_or_equal_to: 0

  def reported?
    self.game.reported
  end

  private
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
