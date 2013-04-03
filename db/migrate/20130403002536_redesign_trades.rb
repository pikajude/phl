class RedesignTrades < ActiveRecord::Migration
  def change
    change_table :trades do |t|
      t.remove :giving_team_id
      t.remove :receiving_team_id
      t.remove :giving
      t.remove :receiving
      t.integer :team_id
      t.integer :opposing_trade_id
    end
  end
end
