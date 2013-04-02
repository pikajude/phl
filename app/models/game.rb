class Game < ActiveRecord::Base
  belongs_to :season
  belongs_to :home_team, class_name: :Team
  belongs_to :away_team, class_name: :Team

  has_many :goals

  validate :different_teams
  before_save :update_scores
  before_save :update_points, if: Proc.new { |t| t.home_score_changed? || t.away_score_changed? }
  before_save :update_seeds, if: Proc.new { |t|
    t.home_team.points_changed? || t.away_team.points_changed?
  }

  has_many :scheduled_attendances
  has_many :attending_players, through: :scheduled_attendances, source: :player

  private
  def different_teams
    errors.add :home_team, "cannot be the same as away team" if self.home_team_id == self.away_team_id
  end

  def update_scores
    self.home_score = 0
    self.away_score = 0
    home = self.home_team.id
    self.goals.each do |goal|
      if goal.team.id == home
        self.home_score += 1
      else
        self.away_score += 1
      end
    end
  end

  def update_points
    overtime = self.goals.where(half: 3).any?
    home, away = *[self.home_team, self.away_team]
    if self.home_score > self.away_score
      if overtime
        home.points += 2
        home.overtime_wins += 1

        away.points += 1
        away.overtime_losses += 1
      else
        home.points += 3
        home.wins += 1

        away.losses += 1
      end
    elsif self.home_score < self.away_score
      if overtime
        away.points += 2
        away.overtime_wins += 1

        home.points += 1
        home.overtime_losses += 1
      else
        away.points += 3
        away.wins += 1

        home.losses += 1
      end
    else
      home.points += 1
      away.points += 1
      home.ties += 1
      away.ties += 1
    end
  end
  
  def update_seeds
    self.home_team.save
    self.away_team.save
    Team.order('points DESC, name ASC').each_with_index do |team,i|
      team.seed = i + 1
      team.save
    end
  end
end
