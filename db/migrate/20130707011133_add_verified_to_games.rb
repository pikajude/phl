class AddVerifiedToGames < ActiveRecord::Migration
  def change
    change_table :games do |t|
      t.boolean :verified, null: false, default: false
    end
  end
end
