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

  has_many :posts,         dependent: :destroy
  has_many :forum_threads, dependent: :destroy

  belongs_to :team

  def color
    self.team.color rescue 0xffffff
  end

  def hex_color
    self.team.hex_color rescue "#ffffff"
  end

  def lightness
    self.team.lightness rescue 1.0
  end

  def self.find_first_by_auth_conditions warden_conditions
    conditions = warden_conditions.dup
    if username = conditions.delete(:username)
      where(conditions).where(["lower(username) = :value", { value: username.downcase }]).first
    else
      where(conditions).first
    end
  end
end
