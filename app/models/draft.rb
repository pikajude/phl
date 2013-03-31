class Draft < ActiveRecord::Base
  has_many :draft_picks
  belongs_to :season
end
