class AddItemsListToUsers < ActiveRecord::Migration
  def change
    change_table :players do |t|
      t.string :dashboard_items
    end
  end
end
