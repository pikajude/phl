class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :title
      t.string :subtitle
      t.integer :moderator_id
      t.integer :team_id
      t.integer :board_id
      t.boolean :is_group

      t.timestamps
    end
  end
end
