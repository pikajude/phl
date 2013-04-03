class Player < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, authentication_keys: [:username]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  ROLES = %w[admin moderator gm agm player banned]

  has_attached_file :avatar, styles: { original: "150x150>" }

  has_many :posts
  has_many :forum_threads
  has_many :scheduled_attendances
  has_many :substitutions, foreign_key: :player_on_id
  has_many :games, through: :substitutions
  has_many :player_proposals
  has_many :trades, through: :player_proposals

  serialize :dashboard_items

  belongs_to :team

  before_save :adjust_stats, if: Proc.new { |p|
    p.games.any?(&:changed?)
  }

  def color
    self.team.color rescue 0xffffff
  end

  def hex_color
    self.team.hex_color rescue "#ffffff"
  end

  def bright
    self.team.bright rescue true
  end

  def self.find_first_by_auth_conditions warden_conditions
    conditions = warden_conditions.dup
    if username = conditions.delete(:username)
      where(conditions).where(["lower(username) = :value", { value: username.downcase }]).first
    else
      where(conditions).first
    end
  end

  def attending? game_id
    self.scheduled_attendances.where(game_id: game_id).any?
  end

  def attend game_id
    att = ScheduledAttendance.new
    att.player = self
    att.game_id = game_id
    att.save
  end

  def unattend game_id
    self.scheduled_attendances.where(game_id: game_id).delete_all
  end

  def dashboard
    (self.dashboard_items || []).map do |ty,id|
      case ty
      when :schedule
        ScheduleBox.find(id)
      end
    end
  end

  private
  def adjust_stats
    self.minutes_played = Substitution.where(player_on_id: self.id).map do |sub|
      sub.off_time - sub.on_time
    end.sum.to_f / 60
    self.goals = Goal.where(scorer_id: self.id).count
    self.assists = Goal.where('first_assist_id = ? OR second_assist_id = ?', self.id, self.id).count
    self.points = self.goals + self.assists
    self.goals_against = Goal.where(scored_against: self.id).count
    self.gaa = self.goals_against / self.minutes_played * 10
    self.ppg = self.points / self.minutes_played * 10
  end
end
