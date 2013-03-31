class CreateTradeProposals < ActiveRecord::Migration
  def change
    create_table :trade_proposals do |t|
      t.string :giving
      t.string :receiving
      t.integer :giving_team_id
      t.integer :receiving_team_id

      t.timestamps
    end
  end
end
