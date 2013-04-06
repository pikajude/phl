class Game < ActiveRecord::Base
  REPORT_GRACE_PERIOD = 3.hours

  belongs_to :season
  belongs_to :home_team, class_name: :Team
  belongs_to :away_team, class_name: :Team

  has_many :goals
  has_many :substitutions

  validate :different_teams
  before_save :update_scores
  before_save :update_seeds
  before_save :update_subs
  before_save :update_stats, if: Proc.new { |t|
    t.substitutions.any?(&:changed?) || t.substitutions.count != t.substitution_count
  }
  before_save :update_substitution_count
  before_save :update_overtime
  after_save  :update_points

  has_many :scheduled_attendances
  has_many :attending_players, through: :scheduled_attendances, source: :player
  has_many :substitutions
  has_many :players, through: :substitutions, class_name: :Player

  def should_have_report?
    self.played_on + REPORT_GRACE_PERIOD < Time.now
  end

  def missing_report?
    !self.reported && self.should_have_report?
  end

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

  def update_overtime
    self.overtime = self.goals.where(half: 3).any?
    true
  end

  def update_points
    self.home_team.update_points
    self.away_team.update_points
  end
  
  def update_seeds
    self.home_team.save
    self.away_team.save
    Team.order('points DESC, LOWER(name) ASC').each_with_index do |team,i|
      team.seed = i + 1
      team.save
    end
  end

  def update_subs
    if self.substitutions.empty?
      %w[home_team away_team].each do |team|
        self.send(team).players.each do |p|
          s = self.substitutions.new
          s.player = p
          s.team = p.team
          s.on_time = 0
          s.off_time = 600
          s.save
        end
      end
    end
  end

  def update_stats
    self.players.each do |player|
     player.minutes_played = player.substitutions.map do |sub|
       sub.off_time - sub.on_time
     end.sum.to_f / 60
     player.goals = Goal.where(scorer_id: player.id).count
     player.assists = Goal.where('first_assist_id = ? OR second_assist_id = ?', player.id, player.id).count
     player.points = player.goals + player.assists
     player.goals_against = Goal.where(scored_against: player.id).count
     player.gaa = player.goals_against / player.minutes_played * 10
     player.ppg = player.points / player.minutes_played * 10
     player.save
    end
  end

  def update_substitution_count
    self.substitution_count = self.substitutions.count
  end
end
