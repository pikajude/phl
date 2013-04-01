class AddWeekAndDayToGames < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.integer :week
      t.integer :day
    end
  end
end
