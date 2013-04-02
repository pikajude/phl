class AddTeamIdToGoals < ActiveRecord::Migration
  def change
    change_table :goals do |t|
      t.integer :team_id
    end
  end
end
