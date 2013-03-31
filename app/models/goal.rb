class Goal < ActiveRecord::Base
  belongs_to :game
  has_one :scorer, class_name: :Player
  has_one :first_assist, class_name: :Player
  has_one :second_assist, class_name: :Player

  validates_presence_of :scorer
end
