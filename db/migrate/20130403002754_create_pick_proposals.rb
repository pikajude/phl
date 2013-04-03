class CreatePickProposals < ActiveRecord::Migration
  def change
    create_table :pick_proposals do |t|
      t.integer :pick_id
      t.integer :trade_id

      t.timestamps
    end
  end
end
