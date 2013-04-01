class AddSeasonNumberToTeams < ActiveRecord::Migration
  def change
    change_table :teams do |t|
      t.integer :season_id
    end
  end
end
