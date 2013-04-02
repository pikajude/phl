class Goal < ActiveRecord::Base
  belongs_to :game
  belongs_to :team
  belongs_to :scorer, class_name: :Player
  belongs_to :first_assist, class_name: :Player
  belongs_to :second_assist, class_name: :Player

  validates_presence_of :scorer
end
