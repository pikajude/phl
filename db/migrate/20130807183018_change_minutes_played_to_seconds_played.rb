class ChangeMinutesPlayedToSecondsPlayed < ActiveRecord::Migration
  def change
    rename_column :players, :minutes_played, :seconds_played
  end
end
