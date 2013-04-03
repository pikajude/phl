class AddUsefulInfoToSubstitutions < ActiveRecord::Migration
  def change
    change_table :substitutions do |t|
      t.integer :on_time
      t.integer :off_time
    end
  end
end
