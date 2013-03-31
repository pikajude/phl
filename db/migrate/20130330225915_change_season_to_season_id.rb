class ChangeSeasonToSeasonId < ActiveRecord::Migration
  def change
    change_table :drafts do |t|
      t.remove :season
      t.integer :season_id
    end
  end
end
