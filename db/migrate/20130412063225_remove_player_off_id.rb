class RemovePlayerOffId < ActiveRecord::Migration
  def change
    change_table :substitutions do |t|
      t.remove :player_off_id
      t.remove :player_on_id
      t.integer :player_id
    end
  end
end
