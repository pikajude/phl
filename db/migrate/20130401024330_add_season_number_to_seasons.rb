class AddSeasonNumberToSeasons < ActiveRecord::Migration
  def change
    change_table :seasons do |t|
      t.integer :season_number
    end
  end
end
