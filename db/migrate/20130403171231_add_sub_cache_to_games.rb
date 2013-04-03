class AddSubCacheToGames < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.integer :substitution_count, null: false, default: 0
    end
  end
end
