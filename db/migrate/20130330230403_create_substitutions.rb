class CreateSubstitutions < ActiveRecord::Migration
  def change
    create_table :substitutions do |t|
      t.integer :game_id
      t.integer :player_on_id
      t.integer :player_off_id

      t.timestamps
    end
  end
end
