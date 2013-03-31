class GivePicksToDrafts < ActiveRecord::Migration
  def change
    change_table :draft_picks do |t|
      t.remove :season
      t.integer :draft_id
    end
  end
end
