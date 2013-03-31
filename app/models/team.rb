class Team < ActiveRecord::Base
  has_many :draft_picks
  has_many :players

  has_attached_file :logo, styles: { retina: "1024x1024>", full: "512x512>", thumb: "128x128>" }
end
