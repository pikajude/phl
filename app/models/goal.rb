class Goal < ActiveRecord::Base
  belongs_to :game
  belongs_to :team
  belongs_to :scorer, class_name: :Player
  belongs_to :first_assist, class_name: :Player
  belongs_to :second_assist, class_name: :Player

  validates_presence_of :scorer, if: :reported?
  validates_presence_of :scored_against, if: :reported?
  validates_presence_of :team, if: :reported?

  validate :correct_players, if: :reported?

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
end
