class ChangeScheduleBox < ActiveRecord::Migration
  def change
    change_table :schedule_boxes do |t|
      t.remove :d1
      t.remove :season_id
      t.string :title
    end
  end
end
