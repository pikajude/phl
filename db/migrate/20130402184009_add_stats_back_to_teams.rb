class AddStatsBackToTeams < ActiveRecord::Migration
  def change
    change_table :teams do |t|
      t.integer :wins,            null: false, default: 0
      t.integer :losses,          null: false, default: 0
      t.integer :ties,            null: false, default: 0
      t.integer :overtime_wins,   null: false, default: 0
      t.integer :overtime_losses, null: false, default: 0
    end
  end
end
