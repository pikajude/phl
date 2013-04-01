class ScheduledAttendance < ActiveRecord::Base
  belongs_to :player
  belongs_to :game

  validates_presence_of :player
  validates_presence_of :game

  validate :correct_team

  private

  def correct_team
    unless self.game.away_team.players.where(id: self.player_id).exists? || self.game.home_team.players.where(id: self.player_id).exists?
      errors.add(:player, "must belong to one of the selected teams")
    end
  end
end
