class MakeScoredAgainstNullable < ActiveRecord::Migration
  def change
    change_table :goals do |t|
      t.remove :scored_against
      t.integer :scored_against
    end
  end
end
