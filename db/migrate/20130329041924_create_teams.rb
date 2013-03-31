class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name,             limit: 64,                    null: false
      t.string :short_name,       limit: 12,                    null: false
      t.string :color,            limit: 6,  default: "000000", null: false

      t.integer :wins,            limit: 2,  default: 0,        null: false
      t.integer :losses,          limit: 2,  default: 0,        null: false
      t.integer :ties,            limit: 2,  default: 0,        null: false
      t.integer :overtime_wins,   limit: 2,  default: 0,        null: false
      t.integer :overtime_losses, limit: 2,  default: 0,        null: false
      t.integer :points,          limit: 2,  default: 0,        null: false

      t.boolean :d1,                         default: true

      t.timestamps
    end
  end
end
