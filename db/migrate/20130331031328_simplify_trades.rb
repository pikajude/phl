class SimplifyTrades < ActiveRecord::Migration
  def change
    rename_table :trade_proposals, :trades
  end
end
