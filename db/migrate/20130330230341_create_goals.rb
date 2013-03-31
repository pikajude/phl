class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.integer :game_id
      t.integer :scorer_id
      t.integer :first_assist_id
      t.integer :second_assist_id
      t.integer :time
      t.integer :half

      t.timestamps
    end
  end
end
