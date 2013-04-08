class DefaultTimeForGoals < ActiveRecord::Migration
  def change
    change_table :goals do |t|
      t.remove :time
      t.integer :time, default: 0
    end
  end
end
