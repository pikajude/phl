class AddReplacesToSubstitutions < ActiveRecord::Migration
  def change
    change_table :substitutions do |t|
      t.integer :replaces_id
    end
  end
end
