class DefaultHomeAndAwayScores < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.remove :home_score
      t.remove :away_score
      t.integer :home_score, null: false, default: 0
      t.integer :away_score, null: false, default: 0
    end
  end
end
