class CreateDashboardBoxes < ActiveRecord::Migration
  def change
    create_table :dashboard_boxes do |t|
      t.string :title
      t.boolean :deletable
      t.integer :player_id
      t.float :relative_size, null: false, default: 1.0
      t.string :template_name

      t.timestamps
    end

    change_table :players do |t|
      t.remove :dashboard_items
    end
  end
end
