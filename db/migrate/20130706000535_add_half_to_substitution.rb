class AddHalfToSubstitution < ActiveRecord::Migration
  def change
    change_table :substitutions do |t|
      t.integer :half, null: false, default: 1
    end
  end
end
