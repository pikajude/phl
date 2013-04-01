class Game < ActiveRecord::Base
  belongs_to :season
  belongs_to :home_team, class_name: :Team
  belongs_to :away_team, class_name: :Team

  before_save :different_teams

  has_many :scheduled_attendances

  private
  def different_teams
    errors.add :home_team, "cannot be the same as away team" if self.home_team_id == self.away_team_id
  end
end
