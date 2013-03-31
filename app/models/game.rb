class Game < ActiveRecord::Base
  belongs_to :season
  has_one :home_team, class_name: :Team
  has_one :away_team, class_name: :Team

  validates_presence_of :home_team
  validates_presence_of :away_team
  
  before_save :different_teams

  private
  def different_teams
    errors.add :home_team, "cannot be the same as away team" if self.home_team_id == self.away_team_id
  end
end
