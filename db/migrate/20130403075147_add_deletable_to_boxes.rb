class AddDeletableToBoxes < ActiveRecord::Migration
  def change
    change_table :schedule_boxes do |t|
      t.boolean :deletable, null: false, default: true
    end
  end
end
