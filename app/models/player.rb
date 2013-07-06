class Player < ActiveRecord::Base
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, authentication_keys: [:username]

  attr_accessible :email, :password, :password_confirmation, :remember_me

  ROLES = %w[admin moderator gm agm player banned]

  has_attached_file :avatar, styles: { original: "150x150>" }

  has_many :posts
  has_many :forum_threads
  has_many :scheduled_attendances
  has_many :substitutions, foreign_key: :player_on_id
  has_many :player_proposals
  has_many :trades, through: :player_proposals
  has_many :dashboard_boxes

  belongs_to :team

  after_create :default_boxes

  def serializable_hash options = {}
    options = {
      only: [:id, :team_id, :signature, :title, :rep, :role, :email,
             :avatar_file_name, :points, :goals, :assists, :goals_against,
             :gaa, :ppg, :minutes_played, :username]
    }.update(options)
    super options
  end

  def games
    self.team.games
  end

  def color
    self.team.color rescue 0xffffff
  end

  def hex_color
    self.team.hex_color rescue "#ffffff"
  end

  def brightness
    self.team.brightness rescue 1
  end

  def self.find_first_by_auth_conditions warden_conditions
    conditions = warden_conditions.dup
    if username = conditions.delete(:username)
      where(conditions).where(["lower(username) = :value", {
        value: username.downcase
      }]).first
    else
      where(conditions).first
    end
  end

  def attending? game_id
    self.scheduled_attendances.where(game_id: game_id).any?
  end

  def attend game
    att = ScheduledAttendance.new
    att.player = self
    att.game = game
    att.save
  end

  def unattend game
    self.scheduled_attendances.where(game_id: game.id).delete_all
  end

  def to_param
    username
  end

  private
  def default_boxes
    self.dashboard_boxes.create([
      {
        title: "Schedule",
        template_name: "schedule",
        relative_size: 1.0
      },
      {
        title: "League Table",
        template_name: "league_table",
        relative_size: 1.0
      }
    ], without_protection: true)
  end
end
