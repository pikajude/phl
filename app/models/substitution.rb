class Substitution < ActiveRecord::Base
  belongs_to :player, foreign_key: "player_on_id", class_name: :Player
  belongs_to :player_off, class_name: :Player
  belongs_to :game
  belongs_to :team
end
