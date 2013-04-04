class AddOvertimeToGames < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.boolean :overtime, default: false
    end
  end
end
