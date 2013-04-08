class CreateDefaultHalf < ActiveRecord::Migration
  def change
    change_table :goals do |t|
      t.remove :half
      t.integer :half, null: false, default: 1
    end
  end
end
