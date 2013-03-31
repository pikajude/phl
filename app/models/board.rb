class Board < ActiveRecord::Base
  #
  # Board(id: 1, title: "Team Boards", is_group: true)
  #   Board(board_id: 1, title: "Team A's Board", is_group: false, team_id: 1)
  #   Board(board_id: 1, title: "Team B's Board", is_group: false, team_id: 2)
  #
  belongs_to :parent_board, class_name: :Board
  has_many :child_boards, class_name: :Board, dependent: :destroy
  belongs_to :team

  def moderator
    User.find self.moderator_id
  end
end
