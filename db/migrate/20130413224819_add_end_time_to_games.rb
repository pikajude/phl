class AddEndTimeToGames < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.integer :length, null: false, default: 600
    end
  end
end
