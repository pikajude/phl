class AddStatsToPlayers < ActiveRecord::Migration
  def change
    change_table :players do |t|
      t.integer :points,         default: 0
      t.integer :goals,          default: 0
      t.integer :assists,        default: 0
      t.integer :goals_against,  default: 0
      t.float   :gaa,            default: 0
      t.float   :ppg,            default: 0
      t.float   :minutes_played, default: 0
    end
  end
end
