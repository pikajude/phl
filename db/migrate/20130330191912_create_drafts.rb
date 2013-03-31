class CreateDrafts < ActiveRecord::Migration
  def change
    create_table :drafts do |t|
      t.integer :season, limit: 2
      t.integer :division, limit: 2

      t.timestamps
    end
  end
end
