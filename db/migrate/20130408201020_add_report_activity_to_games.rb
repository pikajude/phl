class AddReportActivityToGames < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.integer :current_activity_id
      t.datetime :current_activity
      t.integer :last_activity_id
      t.datetime :last_activity
    end
  end
end
