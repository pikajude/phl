class CreateDraftPicks < ActiveRecord::Migration
  def change
    create_table :draft_picks do |t|
      t.integer :season, limit: 2
      t.integer :order, limit: 2

      t.integer :team_id

      t.timestamps
    end
  end
end
