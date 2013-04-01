class CacheValuesOnTeam < ActiveRecord::Migration
  def change
    change_table :teams do |t|
      t.integer :points, null: false, default: 0
      t.integer :seed,   null: false
    end
  end
end
