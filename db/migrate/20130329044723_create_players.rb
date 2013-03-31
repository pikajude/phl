class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :username, limit: 16
      t.integer :team_id
      t.string :signature, limit: 5000
      t.string :title, limit: 32
      t.integer :rep

      t.timestamps
    end
  end
end
