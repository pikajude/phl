class Substitution < ActiveRecord::Base
  belongs_to :player_on, class_name: :Player
  belongs_to :player_off, class_name: :Player
  belongs_to :game
  belongs_to :team
end
