class ColorsToBinary < ActiveRecord::Migration
  def change
    change_table :teams do |t|
      t.remove :color
      t.integer :color, size: 4, default: 0xffffff
    end
  end
end
