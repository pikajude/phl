class DraftPick < ActiveRecord::Base
  belongs_to :draft

  has_many :pick_proposals
  has_many :trades, through: :pick_proposals
end
