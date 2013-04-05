class AddFinishedToGames < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.boolean :finished, null: false, default: false
      t.boolean :reported, null: false, default: false
    end
  end
end
