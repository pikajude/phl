class Season < ActiveRecord::Base
  has_many :drafts
  has_many :games
end
