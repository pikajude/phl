class CreatePlayerProposals < ActiveRecord::Migration
  def change
    create_table :player_proposals do |t|
      t.integer :player_id
      t.integer :trade_id

      t.timestamps
    end
  end
end
