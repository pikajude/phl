class Substitution < ActiveRecord::Base
  has_one :player_on, class_name: :Player
  has_one :player_off, class_name: :Player
  belongs_to :game
end
