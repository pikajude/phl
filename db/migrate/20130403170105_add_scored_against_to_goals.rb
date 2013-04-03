class AddScoredAgainstToGoals < ActiveRecord::Migration
  def change
    change_table :goals do |t|
      t.integer :scored_against, null: false # a player, NOT a team
    end
  end
end
