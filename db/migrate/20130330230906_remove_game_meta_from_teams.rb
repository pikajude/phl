class RemoveGameMetaFromTeams < ActiveRecord::Migration
  def change
    change_table :teams do |t|
      t.remove :wins
      t.remove :losses
      t.remove :ties
      t.remove :overtime_wins
      t.remove :overtime_losses
      t.remove :points
    end
  end
end
