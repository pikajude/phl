class PickProposal < ActiveRecord::Base
  belongs_to :trade
  belongs_to :draft_pick
end
