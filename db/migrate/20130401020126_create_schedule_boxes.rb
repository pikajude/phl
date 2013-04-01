class CreateScheduleBoxes < ActiveRecord::Migration
  def change
    create_table :schedule_boxes do |t|
      t.boolean :d1
      t.integer :season_id

      t.timestamps
    end
  end
end
